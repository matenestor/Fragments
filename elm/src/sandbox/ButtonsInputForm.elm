module Main exposing (..)

import Browser
import Html exposing (Attribute, Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { number : Int
    , content : String
    , name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    { number = 0
    , content = ""
    , name = ""
    , password = ""
    , passwordAgain = ""
    }



-- or simply:
-- Model 0 "" "" "" ""
-- UPDATE


type Msg
    = Increment
    | Decrement
    | Increment10
    | Decrement10
    | Reset
    | Change String
    | Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        -- buttons
        Increment ->
            { model | number = model.number + 1 }

        Decrement ->
            { model | number = model.number - 1 }

        Increment10 ->
            { model | number = model.number + 10 }

        Decrement10 ->
            { model | number = model.number - 10 }

        Reset ->
            { model | number = 0 }

        -- text fields
        Change newContent ->
            { model | content = newContent }

        -- form
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain passwordAgain ->
            { model | passwordAgain = passwordAgain }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        -- buttons
        [ button [ onClick Decrement ] [ text "-1" ]
        , button [ onClick Decrement10 ] [ text "-10" ]
        , div [] [ text (String.fromInt model.number) ]
        , button [ onClick Increment ] [ text "+1" ]
        , button [ onClick Increment10 ] [ text "+10" ]
        , div [] [ button [ onClick Reset ] [ text "reset" ] ]

        -- text fields
        , input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        , div [] [ text ("input length: " ++ String.fromInt (String.length model.content)) ]

        -- form
        , viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    if String.isEmpty model.password && String.isEmpty model.passwordAgain then
        div [] []

    else if model.password == model.passwordAgain then
        if String.length model.password > 8 then
            if
                String.any Char.isUpper model.password
                    && String.any Char.isLower model.password
                    && String.any Char.isDigit model.password
            then
                div [ style "color" "green" ] [ text "OK" ]

            else
                div
                    [ style "color" "red" ]
                    [ text "Password must contain upper-case, lower-case and a number!" ]

        else
            div [ style "color" "red" ] [ text "Password is not long enough!" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]

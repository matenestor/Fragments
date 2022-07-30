module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random


type alias Model =
    { numbers : List Int
    , average : Float
    }


type Msg
    = Roll
    | NewFace Int


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : () -> ( Model, Cmd Msg )
init _ =
    ( { numbers = []
      , average = 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( { numbers = newFace :: model.numbers
              , average = calculateAverage model newFace
              }
            , Cmd.none
            )


calculateAverage : Model -> Int -> Float
calculateAverage model newFace =
    toFloat (List.sum model.numbers + newFace) / toFloat (List.length model.numbers + 1)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ createText model |> text ]
        , div [] [ "average: " ++ String.fromFloat model.average |> text ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]


createText : Model -> String
createText model =
    if List.length model.numbers == 0 then
        "No numbers"

    else
        List.map String.fromInt model.numbers |> String.concat


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

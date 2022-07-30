module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Task
import Time


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , paused : Bool
    }


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | ToggleTime


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none

    else
        Time.every 1000 Tick


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) False
    , Task.perform AdjustTimeZone Time.here
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        ToggleTime ->
            ( { model | paused = not model.paused }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    div []
        [ h1
            [ style "background-color" "blue"
            , style "height" "70px"
            , style "width" "50%"
            ]
            [ text
                (hour
                    ++ ":"
                    ++ minute
                    ++ ":"
                    ++ second
                    ++ (if model.paused then
                            " -> time paused"

                        else
                            ""
                       )
                )
            ]
        , button [ onClick ToggleTime ]
            [ text
                (if model.paused then
                    "Continue"

                 else
                    "Stop"
                )
            ]
        ]


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

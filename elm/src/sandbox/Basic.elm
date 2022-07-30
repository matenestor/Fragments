module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



{-
   multiline
   comment
-}
-- List -- mutable, []
-- Tuple -- immutable, ()
-- Record -- mutable, {}
-- all elements must have the same type


ex_list_strings =
    [ "Alice", "Bob", "Chuck" ]


ex_list_numbers =
    [ 1, 2, 3, 4 ]


increment n =
    n + 1



-- List.isEmpty
-- List.length
-- List.reverse
-- List.sort
-- List.map increment ex_list_numbers


ex_record =
    { first = "Jon"
    , last = "Doe"
    , age = 20
    }



-- ex_record.first / .first ex_record / List.map .first [ex_record, ex_record, ex_record]
-- update Record
--   { ex_record | age = 30 }
-- update with a function


make_older person =
    { person | age = person.age + 1 }



--  make_older ex_record


ex_function : String -> String
ex_function name =
    "Hello " ++ name ++ "!"


ex_condition : String -> String
ex_condition name =
    if name == "Jon Doe" then
        "Hello, unknown!"

    else
        ex_function name



-- THE APP


main =
    Browser.sandbox
        { init = 0
        , view = view
        , update = update
        }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]

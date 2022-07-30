module Main exposing (..)

import Html


type alias User =
    { name : String
    , age : Maybe Int
    }


ali : User
ali =
    User "Alice" Nothing


bob : User
bob =
    User "Bob" (Just 22)


boolToString =
    \n ->
        if n then
            "True"

        else
            "False"


canBuyAlcohool : User -> Bool
canBuyAlcohool user =
    case user.age of
        Just age ->
            age >= 18

        Nothing ->
            False


isReasonableAge : String -> Result String Int
isReasonableAge input =
    case String.toInt input of
        Nothing ->
            Err "That is not a number!"

        Just age ->
            if age < 0 then
                Err "Please try again after you are born."

            else if age > 135 then
                Err "Are you some kind of turtle?"

            else
                Ok age


main =
    Html.text
        (ali.name
            ++ ": "
            ++ boolToString (canBuyAlcohool ali)
            ++ ", "
            ++ bob.name
            ++ ": "
            ++ boolToString (canBuyAlcohool bob)
        )

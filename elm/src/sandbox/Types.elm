module Main exposing (..)

import Html



-- type alias
--   used mainly for models
--   only for Records -> results in a constructor
-- // it is like a class and its **name** is used as a constructor


type alias User =
    { name : String
    , age : Int
    , status : UserStatus
    }



-- custom type
-- // literally a new type; its **values** are used for initialization
-- // possible extra data, but no constructor, thus no assigned attribute names


type UserStatus
    = Regular
    | Visitor



-- use together


ali =
    User "Alice" 20 Regular


bob =
    User "Bob" 22 Visitor



-- easier way to create just a custom type with additional data
-- (Regulars have to specify their age)


type UserPlus
    = RegularPlus String Int String
    | VisitorPlus String
    | Anonymous



-- usage, no way to directly print their names with custom type (no attribute names)
-- need to create a function with pattern matching (switch/match) [1]


aliPlus =
    RegularPlus "aliali123" 20 "Europe"


bobPlus =
    VisitorPlus "bigbob999"


anon =
    Anonymous


toName : UserPlus -> String
toName user =
    case user of
        -- [1] here give attribute names to the extra data
        -- wildcards: RegularPlus name _ _ ->
        RegularPlus name age location ->
            name

        VisitorPlus name ->
            name

        Anonymous ->
            "anonymous"


main =
    Html.text
        ("users: "
            ++ ali.name
            ++ " & "
            ++ bob.name
            ++ " -> Alice: "
            ++ toName aliPlus
            ++ ", Bob: "
            ++ toName bobPlus
            ++ ", anon: "
            ++ toName anon
        )

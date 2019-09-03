module Input exposing (Key(..), Mouse, keyDownDecoder, keyUpDecoder, mousePosition, toKeyDown, toKeyUp)

import Json.Decode



-- Keys for user-game interaction


type Key
    = ArrowUpKeyDown
    | ArrowDownKeyDown
    | ArrowLeftKeyDown
    | ArrowRightKeyDown
    | SpaceKeyDown
    | EnterKeyDown
    | QKeyDown
    | EKeyDown
    | RKeyDown
    | SpaceKeyUp
    | Other


type alias Mouse =
    { x : Float
    , y : Float
    }



-- Decoder for decoding keyDown events to Keys.


keyDownDecoder : Json.Decode.Decoder Key
keyDownDecoder =
    Json.Decode.map toKeyDown (Json.Decode.field "key" Json.Decode.string)



-- Decoder for decoding keyUp events to Keys.


keyUpDecoder : Json.Decode.Decoder Key
keyUpDecoder =
    Json.Decode.map toKeyUp (Json.Decode.field "key" Json.Decode.string)



-- Decoder for decoding mouse movement events to screen coordinates.


mousePosition : Json.Decode.Decoder Mouse
mousePosition =
    Json.Decode.map2 (\x y -> { x = x, y = y })
        (Json.Decode.field "pageX" Json.Decode.float)
        (Json.Decode.field "pageY" Json.Decode.float)



-- Converts key string from KeyboardEvent to Key


toKeyDown : String -> Key
toKeyDown string =
    case string of
        "w" ->
            ArrowUpKeyDown

        "s" ->
            ArrowDownKeyDown

        "a" ->
            ArrowLeftKeyDown

        "d" ->
            ArrowRightKeyDown

        "q" ->
            QKeyDown

        "e" ->
            EKeyDown

        "r" ->
            RKeyDown

        " " ->
            SpaceKeyDown

        "Enter" ->
            EnterKeyDown

        _ ->
            Other


toKeyUp : String -> Key
toKeyUp string =
    case string of
        " " ->
            SpaceKeyUp

        _ ->
            Other

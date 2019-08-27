module Input exposing (Key(..), Mouse, keyDownDecoder, keyUpDecoder, mousePosition, toKeyDown, toKeyUp)

import Json.Decode


type Key
    = ArrowUpKeyDown
    | ArrowDownKeyDown
    | ArrowLeftKeyDown
    | ArrowRightKeyDown
    | SpaceKeyDown
    | QKeyDown
    | EKeyDown
    | RKeyDown
    | SpaceKeyUp
    | Other


type alias Mouse =
    { x : Float
    , y : Float
    }


keyDownDecoder : Json.Decode.Decoder Key
keyDownDecoder =
    Json.Decode.map toKeyDown (Json.Decode.field "key" Json.Decode.string)


keyUpDecoder : Json.Decode.Decoder Key
keyUpDecoder =
    Json.Decode.map toKeyUp (Json.Decode.field "key" Json.Decode.string)


mousePosition : Json.Decode.Decoder Mouse
mousePosition =
    Json.Decode.map2 (\x y -> { x = x, y = y })
        (Json.Decode.field "pageX" Json.Decode.float)
        (Json.Decode.field "pageY" Json.Decode.float)


toKeyDown : String -> Key
toKeyDown string =
    case string of
        "ArrowUp" ->
            ArrowUpKeyDown

        "ArrowDown" ->
            ArrowDownKeyDown

        "ArrowLeft" ->
            ArrowLeftKeyDown

        "ArrowRight" ->
            ArrowRightKeyDown

        "q" ->
            QKeyDown

        "e" ->
            EKeyDown

        "r" ->
            RKeyDown

        " " ->
            SpaceKeyDown

        _ ->
            Other


toKeyUp : String -> Key
toKeyUp string =
    case string of
        " " ->
            SpaceKeyUp

        _ ->
            Other

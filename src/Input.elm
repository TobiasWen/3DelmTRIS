module Input exposing (Key(..), keyDownDecoder, keyUpDecoder, toKeyDown, toKeyUp)

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


keyDownDecoder : Json.Decode.Decoder Key
keyDownDecoder =
    Json.Decode.map toKeyDown (Json.Decode.field "key" Json.Decode.string)


keyUpDecoder : Json.Decode.Decoder Key
keyUpDecoder =
    Json.Decode.map toKeyUp (Json.Decode.field "key" Json.Decode.string)


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

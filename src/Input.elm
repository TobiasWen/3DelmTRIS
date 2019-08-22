module Input exposing (Key(..), keyDownDecoder, keyUpDecoder, toKeyDown, toKeyUp)

import Json.Decode


type Key
    = ArrowUpKeyDown
    | ArrowDownKeyDown
    | ArrowLeftKeyDown
    | ArrowRightKeyDown
    | SpaceKeyDown
    | ArrowUpKeyUp
    | ArrowDownKeyUp
    | ArrowLeftKeyUp
    | ArrowRightKeyUp
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

        " " ->
            SpaceKeyDown

        _ ->
            Other


toKeyUp : String -> Key
toKeyUp string =
    case string of
        "ArrowUp" ->
            ArrowUpKeyUp

        "ArrowDown" ->
            ArrowDownKeyUp

        "ArrowLeft" ->
            ArrowLeftKeyUp

        "ArrowRight" ->
            ArrowRightKeyUp

        " " ->
            SpaceKeyUp

        _ ->
            Other

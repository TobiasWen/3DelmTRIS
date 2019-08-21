module Input exposing (Key(..), KeyEvent, keyDecoder, toKey)

import Json.Decode


type Key
    = ArrowUp KeyEvent
    | ArrowDown KeyEvent
    | ArrowLeft KeyEvent
    | ArrowRight KeyEvent
    | Space KeyEvent
    | Other


type KeyEvent
    = KeyDown
    | KeyUp


keyDecoder : KeyEvent -> Json.Decode.Decoder Key
keyDecoder keyEvent =
    Json.Decode.map (toKey keyEvent (Json.Decode.field "key" Json.Decode.string))


toKey : String -> KeyEvent -> Key
toKey keyEvent string =
    case string of
        "ArrowUp" ->
            ArrowUp

        "ArrowDown" ->
            ArrowDown

        "ArrowLeft" ->
            ArrowLeft

        "ArrowRight" ->
            ArrowRight

        " " ->
            Space

        _ ->
            Other

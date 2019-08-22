module Tetris exposing (main)

import Browser
import Browser.Events
import Input exposing (keyDownDecoder, keyUpDecoder)
import Json.Decode
import Messages exposing (Msg(..))
import Model exposing (Model, getTickRate, initialModel)
import Time exposing (..)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> initialModel
        , subscriptions =
            \model ->
                Sub.batch
                    [ Time.every (getTickRate model) (\_ -> Tick)
                    , Browser.Events.onKeyDown (Json.Decode.map KeyEvent keyDownDecoder)
                    , Browser.Events.onKeyUp (Json.Decode.map KeyEvent keyUpDecoder)
                    ]
        , view = View.view
        , update = \msg model -> update msg model
        }

module Tetris exposing (main)

import Browser
import Browser.Dom exposing (Element, getElement)
import Browser.Events
import Input exposing (keyDownDecoder, keyUpDecoder, mousePosition)
import Json.Decode
import Messages exposing (Msg(..))
import Model exposing (Model, getTickRate, initialModel)
import Task
import Time exposing (..)
import Update exposing (update)
import View exposing (view)



{-
   3DELMTRIS
-}


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
                    , Browser.Events.onMouseMove (Json.Decode.map MouseEvent mousePosition)
                    , Browser.Events.onResize GetWindowsSize
                    ]
        , view = View.view
        , update = \msg model -> update msg model
        }

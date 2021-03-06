module Tetris exposing (main)

import Browser
import Browser.Events
import Input exposing (keyDownDecoder, keyUpDecoder, mousePosition)
import Json.Decode
import Messages exposing (Msg(..))
import Model exposing (GameState(..), Model, getTickRate, initialModel)
import Time exposing (every)
import Update exposing (update)
import View.View as View exposing (view)



{-
   3DELMTRIS - main entry point of the elm application.
-}


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> initialModel
        , subscriptions =
            \model ->
                Sub.batch
                    [ Time.every (getTickRate model)
                        (\_ ->
                            if model.gameState == Running then
                                Tick

                            else
                                NoOp
                        )
                    , Browser.Events.onKeyDown (Json.Decode.map KeyEvent keyDownDecoder)
                    , Browser.Events.onKeyUp (Json.Decode.map KeyEvent keyUpDecoder)
                    , Browser.Events.onMouseMove (Json.Decode.map MouseEvent mousePosition)
                    , Browser.Events.onResize GetWindowsSize
                    ]
        , view = View.view
        , update = \msg model -> update msg model
        }

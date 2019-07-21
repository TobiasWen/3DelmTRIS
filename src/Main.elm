module Tetris exposing (main)

import Browser
import Model exposing (Model, initialModel)
import Update exposing (Msg, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = View.view
        , update = \msg model -> ( Update.update msg model, Cmd.none )
        }

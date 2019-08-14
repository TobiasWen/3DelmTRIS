module Tetris exposing (main)

import Browser
import Messages exposing (Msg)
import Model exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> initialModel
        , subscriptions = \_ -> Sub.none
        , view = View.view
        , update = \msg model -> update msg model
        }

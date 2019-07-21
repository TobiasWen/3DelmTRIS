module View exposing (view)

import Html exposing (Html, br, button, div, p, span, text)
import Html.Attributes exposing (class, disabled, style)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Update exposing (Msg)



-- Simple placeholder. Maybe this should be placed in an own folder depending
-- on the number of files regarding the view.


view : Model -> Html Msg
view model =
    div [ Html.Attributes.style "display" "flex", Html.Attributes.style "justify-content" "center" ]
        [ Html.text "Hallo Welt!"
        ]

module View exposing (view)

import Html exposing (Html, br, button, div, h1, h2, p, span, text)
import Html.Attributes exposing (class, disabled, height, id, style, width)
import Html.Events exposing (onClick)
import Messages exposing (Msg)
import Model exposing (Model)
import Scene exposing (renderGameScene, renderNextTetroidScene)
import UI exposing (renderControls, renderGameOverText)


view : Model -> Html Msg
view model =
    div []
        [ div
            [ style "width" "80%"
            , style "display" "flex"
            , style "text-align" "center"
            , style "margin" "auto"
            , style "max-height" (String.fromFloat (toFloat model.windowSize.height) ++ "px")
            ]
            [ div [ style "flex" "80%" ]
                [ h1 [] [ text "3DELMTRIS" ]
                , Scene.renderGameScene model
                , UI.renderGameOverText model.gameOver
                ]
            , div
                [ style "flex" "20%"
                ]
                [ UI.renderControls
                , Scene.renderNextTetroidScene model
                ]
            ]
        ]

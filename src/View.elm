module View exposing (view)

import Css exposing (margin, padding, px)
import Css.Global exposing (body, global)
import Html exposing (Html, br, button, div, h1, h2, p, span, text)
import Html.Attributes exposing (class, disabled, height, id, style, width)
import Html.Events exposing (onClick)
import Html.Styled as Styled
import Messages exposing (Msg)
import Model exposing (Model)
import Scene exposing (renderGameScene, renderNextTetroidScene)
import UI exposing (renderControls, renderGameOverText)


view : Model -> Html Msg
view model =
    div
        [ style "font-family" "\"HelveticaNeue-Light\", \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif"
        , style "font-weight" "250"
        , style "background-color" "#E1F0F0"
        , style "background-image" "linear-gradient(to left bottom, #f9c6e3, #e8d1f4, #d9dcfc, #d1e5fb, #d3ebf6, #d2eef6, #d1f1f5, #d2f4f3, #c6f7f5, #b9faf6, #acfcf7, #9efff7)"
        , style "color" "#EEE"
        ]
        [ Styled.toUnstyled
            (Styled.div
                []
                [ global
                    [ body [ margin (px 0), padding (px 0) ] ]
                ]
            )
        , div
            [ style "width" "75%"
            , style "display" "flex"
            , style "text-align" "center"
            , style "margin" "auto"
            , style "max-height" (String.fromFloat (toFloat (model.windowSize.height + 70)) ++ "px")
            , style "max-width" "1500px"
            ]
            [ div [ style "flex" "60%" ]
                [ h1
                    [ style "color" "#00A58E"
                    , style "font-size" "70px"
                    , style "font-style" "normal"
                    , style "font-weight" "700"
                    , style "line-height" "28pt"
                    ]
                    [ text
                        "3D"
                    , span [ style "font-family" "\"Source Sans Pro\", \"Trebuchet MS\", \"Lucida Grande\", \"Bitstream Vera Sans\", \"Helvetica Neue\", sans-serif", style "font-weight" "200" ] [ text "elm" ]
                    , text "TRIS"
                    , UI.renderGameOverText model.gameOver
                    ]
                , Scene.renderGameScene model
                ]
            , div
                [ style "background" "#523D98CC"
                , style "padding" "40px"
                , style "box-shadow" "0px 0px 12px 5px rgba(0,0,0,0.20)"
                ]
                [ UI.renderscore { id = 0, name = "", score = 5000 }
                , UI.renderHighscore model.highscores
                , Scene.renderNextTetroidScene model
                , UI.renderControls
                ]
            ]
        ]

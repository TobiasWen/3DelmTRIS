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
import Score exposing (ScoresData(..))
import UI exposing (renderControls, renderGameOverScreen)


view : Model -> Html Msg
view model =
    div
        [ style "font-family" "\"HelveticaNeue-Light\", \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif"
        , style "font-weight" "250"
        , style "position" "absolute"
        , style "width" "100%"
        , style "height" "100%"
        , style "background-color" "#E1F0F0"
        , style "background" "linear-gradient(45deg, #fc00ff, #00dbde)"
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
            ]
            [ div [ style "flex" "60%" ]
                [ h1
                    [ style "color" "rgb(235, 255, 252)"
                    , style "font-size" "70px"
                    , style "font-style" "normal"
                    , style "font-weight" "700"
                    , style "line-height" "28pt"
                    , style "text-shadow" "rgb(0, 255, 219) 2px 2px 8px"
                    ]
                    [ text
                        "3D"
                    , span [ style "font-family" "\"Source Sans Pro\", \"Trebuchet MS\", \"Lucida Grande\", \"Bitstream Vera Sans\", \"Helvetica Neue\", sans-serif", style "font-weight" "200" ] [ text "elm" ]
                    , text "TRIS"
                    ]
                , if model.gameOver then
                    UI.renderGameOverScreen model

                  else
                    Scene.renderGameScene model
                ]
            , div
                [ style "background" "rgba(4, 4, 4, 0.8)"
                , style "padding" "0 40px 0 40px"
                , style "height" "100vh"
                , style "box-shadow" "rgba(0, 0, 0, 0.2) 0px 0px 12px 5px"
                ]
                [ UI.renderscore model.score
                , case model.highscores of
                    Loaded scores ->
                        UI.renderHighscore scores.scores

                    _ ->
                        UI.renderHighscore []
                , Scene.renderNextTetroidScene model
                , UI.renderControls
                ]
            ]
        ]

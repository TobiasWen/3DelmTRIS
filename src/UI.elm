module UI exposing (myh2, renderControls, renderGameOverScreen, renderHighscore, renderscore)

import Html exposing (Html, button, div, h1, h2, input, li, span, text, ul)
import Html.Attributes exposing (placeholder, style)
import Html.Events exposing (onClick, onInput)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Score exposing (Score)
import Table exposing (Row, table)


renderGameOverScreen : Model -> Html Msg
renderGameOverScreen model =
    div
        [ style "height" "50%"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ div
            [ style "position" "relative"
            , style "background" "rgba(4, 4, 4, 0.8)"
            , style "padding" "20px 40px"
            , style "box-shadow" "rgba(0, 0, 0, 0.2) 0px 0px 12px 5px"
            ]
            [ h1 myh2 [ text "Game Over!" ]
            , input
                [ Html.Attributes.type_ "text"
                , placeholder "Enter your name..."
                , style "width" "100%"
                , style "border" "2px solid rgb(255, 255, 255)"
                , style "border-radius" "4px"
                , style "margin" "8px 0"
                , style "outline" "none"
                , style "padding" "8px"
                , style "box-sizing" "border-box"
                , style "transition" ".3s"
                , style "box-shadow" "rgb(246, 0, 255) 2px 2px 8px"
                , onInput NewName
                ]
                []
            , button
                [ style "background" "rgba(4, 4, 4, 0.8)"
                , style "color" "#fff"
                , style "text-transform" "uppercase"
                , style "text-decoration" "none"
                , style "text-shadow" "rgb(246, 0, 255) 2px 2px 8px"
                , style "padding" "20px"
                , style "border" "1px solid rgb(246, 0, 255)"
                , style "display" "inline-block"
                , style "transition" "all 0.4s ease 0s"
                , style "box-shadow" "rgb(246, 0, 255) 2px 2px 8px"
                , style "margin-top" "1em"
                , onClick (SendScore { name = model.playerName, score = model.score, rank = 0 })
                ]
                [ text "Submit Score & Restart" ]
            ]
        ]


renderControls : Html Msg
renderControls =
    div
        [ style "display" "block"
        , style "text-align" "left"
        , style "margin" "auto"
        , style "margin-top" "20px"
        ]
        [ h2 myh2 [ text "Controls" ]
        , div
            [ style "margin-left" "35px" ]
            [ renderList controls ]
        ]


controls : List String
controls =
    [ "SPACE - Down faster", "\u{2000}", "W - Forward", "A - Left", "S - Backwards", "D - Right", "\u{2000}", "Q - Rotate X", "E - Rotate Y", "R - Rotate Z", "Enter - Restart" ]


renderList : List String -> Html Msg
renderList lst =
    lst
        |> List.map (li [] << List.singleton << text)
        |> ul
            [ style "list-style-type" "none"
            , style "margin" "0"
            , style "padding" "0"
            ]


renderscore : Int -> Html Msg
renderscore score =
    div []
        [ h2 myh2 [ text "Score" ]
        , span
            [ style "font-size" "45px"
            , style "font-weight" "500"
            ]
            [ text (String.fromInt score) ]
        ]


renderHighscore : List Score -> Html Msg
renderHighscore highscoresList =
    div []
        [ h2 myh2 [ text "Highscores" ]
        , table highscoreRow highscoresList
        ]


highscoreRow : Row Score Msg
highscoreRow =
    [ rankCell
    , nameCell
    , scoreCell
    ]


rankCell : Score -> Html Msg
rankCell highscore =
    Html.div [] [ text (String.concat [ "# ", String.fromInt highscore.rank ]) ]


nameCell : Score -> Html Msg
nameCell highscore =
    Html.div [] [ text highscore.name ]


scoreCell : Score -> Html Msg
scoreCell highscore =
    Html.div [] [ text (String.fromInt highscore.score) ]


myh2 : List (Html.Attribute msg)
myh2 =
    [ style "color" "#FFF"
    , style "margin" "30px"
    , style "text-shadow" "2px 2px 8px #f600ff"
    , style "padding-bottom" "10px"
    , style "border-bottom" "1px solid #f300ff"
    , style "text-align" "center"
    , style "font-family" "Consolas, monaco, monospace"
    , style "font-size" "24pt"
    , style "font-style" "normal"
    , style "font-weight" "500"
    , style "line-height" "22pt"
    ]

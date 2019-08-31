module UI exposing (myh2, renderControls, renderGameOverText, renderHighscore, renderscore)

import Html exposing (Html, br, button, div, h1, h2, li, p, span, text, ul)
import Html.Attributes exposing (class, disabled, height, id, style, width)
import Messages exposing (Msg)
import Model exposing (Score)
import Table exposing (Cell, Row, table)


renderGameOverText : Bool -> Html Msg
renderGameOverText isGameOver =
    let
        checkForVisibility =
            if isGameOver then
                style "visibility" "visible"

            else
                style "visibility" "hidden"
    in
    div
        [ style "position" "absolute"
        , style "left" "50%"
        , checkForVisibility
        ]
        [ div
            [ style "position" "relative"
            , style "left" "-50%"
            , style "background" "#505050"
            ]
            [ h1
                [ style "color" "#" ]
                [ text "Game Over! Press F5 to restart!" ]
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


controls =
    [ "SPACE - Down faster", "\u{2000}", "W - Forward", "A - Left", "S - Backwards", "D - Right", "\u{2000}", "Q - Rotate X", "E - Rotate Y", "R - Rotate Z", "F5 - Restart" ]


renderList : List String -> Html Msg
renderList lst =
    lst
        |> List.map (li [] << List.singleton << text)
        |> ul
            [ style "list-style-type" "none"
            , style "margin" "0"
            , style "padding" "0"
            ]


renderscore : Score -> Html Msg
renderscore score =
    div []
        [ h2 myh2 [ text "Score" ]
        , span
            [ style "font-size" "45px"
            , style "font-weight" "500"
            ]
            [ text (String.fromInt score.score) ]
        ]


renderHighscore : List Score -> Html Msg
renderHighscore highscoresList =
    div []
        [ h2 myh2 [ text "Highscores" ]
        , table highscoreRow highscoresList
        ]


highscoreRow : Row Score Msg
highscoreRow =
    [ idCell
    , nameCell
    , scoreCell
    ]


idCell : Score -> Html Msg
idCell highscore =
    Html.div [] [ text (String.fromInt highscore.id) ]


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

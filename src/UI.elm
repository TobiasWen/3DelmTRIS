module UI exposing (renderControls, renderGameOverText)

import Html exposing (Html, br, button, div, h1, h2, li, p, span, text, ul)
import Html.Attributes exposing (class, disabled, height, id, style, width)
import Messages exposing (Msg)


renderGameOverText : Bool -> Html Msg
renderGameOverText isGameOver =
    let
        checkForVisibility =
            if isGameOver then
                style "visibility" "visible"

            else
                style "visibility" "hidden"
    in
    h1
        [ checkForVisibility ]
        [ text "Game Over! Press F5 to restart!" ]


renderControls : Html Msg
renderControls =
    div
        [ style "display" "block"
        , style "text-align" "left"
        , style "margin" "auto"
        , style "margin-top" "4em"
        ]
        [ h2 [] [ text "Controls" ]
        , p
            []
            [ renderList controls ]
        ]


controls =
    [ "SPACE - Down Faster", "W - Forward", "A - Left", "S - Backwards", "D - Right", "Q - Rotate X", "E - Rotate Y", "R - Rotate Z", "F5 - Restart" ]


renderList : List String -> Html msg
renderList lst =
    lst
        |> List.map (li [] << List.singleton << text)
        |> ul []


renderscore : Int -> Html msg
renderscore score =
    div []
        [ h2 [] [ text "Score" ]
        , span [] [ text (String.fromInt score) ]
        ]

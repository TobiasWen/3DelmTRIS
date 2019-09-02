module Table exposing (Cell, Row, table)

import Html exposing (Html)
import Html.Attributes exposing (class, style)


type alias Cell record msg =
    record -> Html msg


type alias Row record msg =
    List (Cell record msg)


table : Row record msg -> List record -> Html msg
table row records =
    Html.table [ class "table", style "width" "100%", style "border-collapse" "collapse" ] (List.map (tableRow row) records)


tableRow : Row record msg -> record -> Html msg
tableRow row record =
    Html.tr [ class "table-row" ] (List.map (tableCell record) row)


tableCell : record -> Cell record msg -> Html msg
tableCell record cell =
    Html.td [ class "table-cell", style "border-bottom" "1px solid #ddd", style "paddin" "8px" ] [ cell record ]

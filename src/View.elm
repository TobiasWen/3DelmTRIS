module View exposing (view)

import Grid exposing (Color, Grid, Position, mergeGrids)
import Html exposing (Html, br, button, div, h1, p, span, text)
import Html.Attributes exposing (class, disabled, height, style, width)
import Html.Events exposing (onClick)
import List exposing (concat)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, toRecord, vec3)
import Messages exposing (Msg)
import Model exposing (Model)
import WebGL exposing (Mesh, Shader)



-- Simple placeholder. Maybe this should be placed in an own folder depending
-- on the number of files regarding the view.


view : Model -> Html Msg
view model =
    let
        fullgrid =
            playAreaEntity model
                ++ cellsToWebGLEnteties
                    model
                    (case model.activeTetroid of
                        Just tetroid ->
                            mergeGrids model.grid tetroid.grid

                        Nothing ->
                            model.grid
                    )
    in
    div []
        [ displayGameOverText model.gameOver
        , WebGL.toHtml
            [ width 1200
            , height 800
            , style "display" "block"
            , style "margin" "auto"
            ]
            fullgrid
        ]


displayGameOverText : Bool -> Html Msg
displayGameOverText isGameOver =
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



--Enteties


type alias Cell =
    { position : Position
    , color : Color
    }


type alias Uniforms =
    { rotation : Mat4
    , perspective : Mat4
    , camera : Mat4
    , shade : Float
    }


uniforms : Model -> Uniforms
uniforms model =
    { rotation = Mat4.identity
    , perspective = manipulatePerspective 1200 800 model
    , camera = Mat4.makeLookAt (vec3 (model.dimensions.width / 2) 0 (model.dimensions.depth / 2)) (vec3 0 0 0) (vec3 0 -1 0)
    , shade = 0.8
    }



--calc circle


manipulatePerspective : Float -> Float -> Model -> Mat4
manipulatePerspective width height model =
    let
        sensitivity =
            0.32

        eye =
            vec3 (0.2 * cos (degrees (model.mousePosition.x * sensitivity))) -(0.5 - model.mousePosition.y / height) (0.2 * sin (degrees (model.mousePosition.x * sensitivity)))
                |> Vec3.normalize
                |> Vec3.scale 18
    in
    Mat4.mul
        (Mat4.makePerspective 60 (width / height) 0.01 1000)
        (Mat4.makeLookAt eye (vec3 0 -9 0) Vec3.j)



--COORDINATE HELPER
--                  (0,0,6)            (0,6,6)
--               ___________________
--             / |               / |
--   (0,0,0) /__|_______________/__| (6,0,0)
--          |   |              |   |
--          |   |              |   |
--          |   |  (0,13,6)    |   |   (6,13,6)
--          |   | _____________|___|
--          |  /               |  /
-- (0,13,0) |/_________________|/  (0,13,0)
--


cellsToWebGLEnteties : Model -> List Cell -> List WebGL.Entity
cellsToWebGLEnteties model cells =
    case cells of
        [] ->
            []

        [ x ] ->
            [ WebGL.entity
                vertexShader
                fragmentShader
                (cellToMesh x)
                (uniforms model)
            ]

        x :: xs ->
            concat
                [ [ WebGL.entity
                        vertexShader
                        fragmentShader
                        (cellToMesh x)
                        (uniforms model)
                  ]
                , cellsToWebGLEnteties model xs
                ]



-- Mesh


type alias Vertex =
    { color : Vec3
    , position : Vec3
    }


cellToMesh : Cell -> Mesh Vertex
cellToMesh cell =
    let
        cellColor =
            toRecord (vec3 (toFloat cell.color.r) (toFloat cell.color.g) (toFloat cell.color.b))

        cellPosition =
            toRecord (vec3 cell.position.x cell.position.y cell.position.z)

        --right front top
        rft =
            vec3 (cellPosition.x + 1) (cellPosition.y + 1) cellPosition.z

        -- left front top
        lft =
            vec3 cellPosition.x (cellPosition.y + 1) cellPosition.z

        --left back top
        lbt =
            vec3 cellPosition.x (cellPosition.y + 1) (cellPosition.z + 1)

        --right back top
        rbt =
            vec3 (cellPosition.x + 1) (cellPosition.y + 1) (cellPosition.z + 1)

        --right back bot
        rbb =
            vec3 (cellPosition.x + 1) cellPosition.y (cellPosition.z + 1)

        --right front bot
        rfb =
            vec3 (cellPosition.x + 1) cellPosition.y cellPosition.z

        --left front bot
        lfb =
            vec3 cellPosition.x cellPosition.y cellPosition.z

        -- left back bot
        lbb =
            vec3 cellPosition.x cellPosition.y (cellPosition.z + 1)

        shade1 =
            vec3 (cellColor.x - 30) (cellColor.y - 30) (cellColor.z - 30)

        shade2 =
            vec3 (cellColor.x - 50) (cellColor.y - 50) (cellColor.z - 50)
    in
    [ face shade2 rft rfb rbb rbt -- right
    , face shade1 rft rfb lfb lft -- front
    , face (vec3 cellColor.x cellColor.y cellColor.z) rft lft lbt rbt -- top
    , face shade1 rfb lfb lbb rbb -- back
    , face (vec3 cellColor.x cellColor.y cellColor.z) lft lfb lbb lbt --left
    , face shade2 rbt rbb lbb lbt -- bot
    ]
        |> List.concat
        |> WebGL.triangles


playAreaEntity : Model -> List WebGL.Entity
playAreaEntity model =
    [ WebGL.entity
        vertexShader
        fragmentShader
        (playareaBase model)
        (uniforms model)
    ]


playareaBase : Model -> Mesh Vertex
playareaBase model =
    let
        color =
            toRecord (vec3 70 70 70)

        plateheight =
            1.5

        --right front top
        rft =
            vec3 model.dimensions.width model.dimensions.height 0

        -- left front top
        lft =
            vec3 0 model.dimensions.height 0

        --left back top
        lbt =
            vec3 0 model.dimensions.height model.dimensions.depth

        --right back top
        rbt =
            vec3 model.dimensions.width model.dimensions.height model.dimensions.depth

        --right back bot
        rbb =
            vec3 model.dimensions.width (model.dimensions.height + plateheight) model.dimensions.depth

        --right front bot
        rfb =
            vec3 model.dimensions.width (model.dimensions.height + plateheight) 0

        --left front bot
        lfb =
            vec3 0 (model.dimensions.height + plateheight) 0

        -- left back bot
        lbb =
            vec3 0 (model.dimensions.height + plateheight) model.dimensions.depth

        shade1 =
            vec3 (color.x - 30) (color.y - 30) (color.z - 30)

        shade2 =
            vec3 (color.x - 50) (color.y - 50) (color.z - 50)
    in
    [ face shade2 rft rfb rbb rbt -- right
    , face shade1 rft rfb lfb lft -- front
    , face (vec3 color.x color.y color.z) rft lft lbt rbt -- top
    , face shade1 rfb lfb lbb rbb -- back
    , face (vec3 color.x color.y color.z) lft lfb lbb lbt --left
    , face shade2 rbt rbb lbb lbt -- bot
    ]
        |> List.concat
        |> WebGL.triangles


face : Vec3 -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex, Vertex )
face color a b c d =
    let
        vertex position =
            Vertex (Vec3.scale (1 / 255) color) position
    in
    [ ( vertex a, vertex b, vertex c )
    , ( vertex c, vertex d, vertex a )
    ]



-- Shaders


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        uniform mat4 rotation;
        varying vec3 vcolor;
        void main () {
            gl_Position = perspective * camera * rotation * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        uniform float shade;
        varying vec3 vcolor;
        void main () {
            gl_FragColor = shade * vec4(vcolor, 1.0);
        }
    |]

module View exposing (view)

import Grid exposing (Color, Grid, Position, mergeGrids)
import Html exposing (Html, br, button, div, p, span, text)
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
    WebGL.toHtml
        [ width 1000
        , height 1000
        , style "display" "block"
        , style "margin" "auto"
        ]
        (cellsToWebGLEnteties
            (case model.activeTetroid of
                Just tetroid ->
                    mergeGrids model.grid tetroid.grid

                Nothing ->
                    model.grid
            )
        )



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


uniforms : Uniforms
uniforms =
    { rotation = Mat4.identity
    , perspective = Mat4.makePerspective 60 1 0.001 1000
    , camera = Mat4.makeLookAt (vec3 6 6 -25) (vec3 6 6 6) (vec3 0 -1 0) -- inverted Camera
    , shade = 0.8
    }



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


cellsToWebGLEnteties : List Cell -> List WebGL.Entity
cellsToWebGLEnteties cells =
    case cells of
        [] ->
            []

        [ x ] ->
            [ WebGL.entity
                vertexShader
                fragmentShader
                (cellToMesh x)
                uniforms
            ]

        x :: xs ->
            concat
                [ [ WebGL.entity
                        vertexShader
                        fragmentShader
                        (cellToMesh x)
                        uniforms
                  ]
                , cellsToWebGLEnteties xs
                ]



-- Mesh


type alias Vertex =
    { color : Vec3
    , position : Vec3
    }


cellToMesh : Cell -> Mesh Vertex
cellToMesh cellWithoutFloats =
    let
        cellColor =
            toRecord (vec3 (toFloat cellWithoutFloats.color.r) (toFloat cellWithoutFloats.color.g) (toFloat cellWithoutFloats.color.b))

        cellPosition =
            toRecord (vec3 (toFloat cellWithoutFloats.position.x) (toFloat cellWithoutFloats.position.y) (toFloat cellWithoutFloats.position.z))

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

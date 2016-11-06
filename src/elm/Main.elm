import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html

import WebGL exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)

model : number
model = 0

type Msg = NoOp

main : Program Never
main =
  Html.program 
    { init = (0, Cmd.none)
    , view = view
    , subscriptions = subscriptions
    , update = update 
    }

update msg model =
    case msg of
        NoOp -> (model, Cmd.none)
        
subscriptions model =
    Sub.none

mesh1 =
    TriangleStrip 
        [ {position = (vec3 -1 0 0), color = (vec3 1 1 0)}
        , {position = (vec3 0 0 0), color = (vec3 1 1 0)}
        , {position = (vec3 0 1 0), color = (vec3 1 1 0)}
        , {position = (vec3 -1 1 0), color = (vec3 1 1 0)}
        , {position = (vec3 -1 0 0), color = (vec3 1 1 0)}
        ]

mesh2 =
    TriangleStrip 
        [ {position = (vec3 -0.95 0.95 0), color = (vec3 1 0 0)}
        , {position = (vec3 -0.05 0.95 0), color = (vec3 1 0 0)}
        , {position = (vec3 -0.05 0.05 0), color = (vec3 1 0 0)}
        , {position = (vec3 -0.95 0.95 0), color = (vec3 1 0 0)}
        , {position = (vec3 -0.95 0.05 0), color = (vec3 1 0 0)}
        ]

view model =
    WebGL.toHtml [width 400, height 400]
    ( [ render vertexShader fragmentShader mesh1 {} ] ++
        [ render vertexShader fragmentShader mesh2 {} ] )
    
-- SHADERS
vertexShader : Shader { attr | position:Vec3, color:Vec3 } {} { vcolor:Vec3}
vertexShader = [glsl|
    attribute vec3 position;
    attribute vec3 color;
    
    varying vec3 vcolor;
    
    void main () {
        gl_Position = vec4(position, 1.0);
        vcolor = color;
    }
|]

fragmentShader : Shader {} {} { vcolor:Vec3 }
fragmentShader = [glsl|
    precision mediump float;
    
    varying vec3 vcolor;
    
    void main () {
        gl_FragColor = vec4(vcolor,1);
    }
|]
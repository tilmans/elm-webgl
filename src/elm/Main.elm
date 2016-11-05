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

mesh =
    Triangle 
        [( { position = (vec3 0 0 0) }
         , { position = (vec3 1 0 0) }
         , { position = (vec3 1 1 0) }
        )]

view model =
    WebGL.toHtml [width 400, height 400]
    [ render vertexShader fragmentShader mesh {} ]
    
-- SHADERS
vertexShader : Shader { attr | position:Vec3 } {} {}
vertexShader = [glsl|
    attribute vec3 position;
    void main () {
        gl_Position = vec4(position, 1.0);
    }
|]

fragmentShader : Shader {} {} {}
fragmentShader = [glsl|
    precision mediump float;
    void main () {
        gl_FragColor = vec4(0,0,0,1);
    }
|]
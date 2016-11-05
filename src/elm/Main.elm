import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import WebGL exposing (..)
import Color exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)
import AnimationFrame

-- APP
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
        _ -> (model, Cmd.none)
        
subscriptions model =
    Sub.none

-- MODEL
type alias Model = 
    { rotation: Float 
    }

model : number
model = 0

type Msg = NoOp

cube =
    Triangle 
        [
            (
                { position = (vec3 0 0 0)
                , color = (vec3 0 0 0)
                }
            ,
                { position = (vec3 1 0 0)
                , color = (vec3 0 0 0)
                }
            ,
                { position = (vec3 1 1 0)
                , color = (vec3 0 0 0)
                }
            )
        ]

view model =
    WebGL.toHtml [width 400, height 400]
    [ render vertexShader fragmentShader cube (uniforms model) ]
    
uniforms : Float -> { rotation:Mat4, perspective:Mat4, camera:Mat4, shade:Float }
uniforms t =
  { rotation = mul (makeRotate (3*t) (vec3 0 1 0)) (makeRotate (2*t) (vec3 1 0 0))
  , perspective = makePerspective 45 1 0.01 100
  , camera = makeLookAt (vec3 0 0 5) (vec3 0 0 0) (vec3 0 1 0)
  , shade = 0.8
  }


-- SHADERS

vertexShader : Shader { attr | position:Vec3, color:Vec3 }
                      { unif | rotation:Mat4, perspective:Mat4, camera:Mat4 }
                      { vcolor:Vec3 }
vertexShader = [glsl|
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


fragmentShader : Shader {} { u | shade:Float } { vcolor:Vec3 }
fragmentShader = [glsl|
    precision mediump float;
    uniform float shade;
    varying vec3 vcolor;
    void main () {
        gl_FragColor = shade * vec4(vcolor, 1.0);
    }
|]
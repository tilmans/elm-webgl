module P_1_0 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import WebGL exposing (toHtml)
import Mouse
import Color exposing (..)

import Quad exposing (..)

type alias Model =
    { width: Float
    , colorBack: (Float, Float, Float)
    , colorFront: (Float, Float, Float)
    , offsetLeft: Int
    , offsetTop: Int
    }

type Msg = MouseMsg Mouse.Position

init offsetLeft offsetTop=
    (Model 0 (1,0,0) (0,1,0) offsetLeft offsetTop)

widthFor x off =
    Basics.min 1.0 (Basics.max 0 (((toFloat x)-(toFloat off))/400))
    
colorsFor y off = 
    let
        offset = Basics.min 1.0 ( Basics.max 0 (((toFloat y)-(toFloat off))/400) )
        radian = (degrees 360*offset)
        rgbF = toRgb (hsl radian 1 0.5)
        rgbB = toRgb (hsl (radian * -1) 1 0.5)
    in
        ( ((toFloat rgbF.red)/255, (toFloat rgbF.green)/255, (toFloat rgbF.blue)/255)
        , ((toFloat rgbB.red)/255, (toFloat rgbB.green)/255, (toFloat rgbB.blue)/255)
        )

update msg model =
    case msg of
        MouseMsg position -> 
            let
                width = widthFor position.x model.offsetLeft
                (colorFront, colorBack) = colorsFor position.y model.offsetTop
            in
            ({model|
                width=width,
                colorFront=colorFront,
                colorBack=colorBack
            }, Cmd.none)
        
view model =
    WebGL.toHtml [width 400, height 400]
        (   (quad 1 model.colorBack) 
        ++  (quad model.width model.colorFront) 
        )
    

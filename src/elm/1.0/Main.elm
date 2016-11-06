import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import WebGL exposing (toHtml)
import Mouse
import Color exposing (..)

import Quad exposing (..)

type alias Model =
    { width: Float
    , colorBack: (Float, Float, Float)
    , colorFront: (Float, Float, Float)
    }

type Msg = MouseMsg Mouse.Position

main : Program Never
main =
  Html.program 
    { init = ((Model 0 (1,0,0) (0,1,0)), Cmd.none)
    , view = view
    , subscriptions = subscriptions
    , update = update 
    }

widthFor x =
    Basics.min 1.0 (x/400)
    
colorsFor y = 
    let
        offset = Basics.min 1.0 (y/400)
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
                width = widthFor (toFloat position.x)
                (colorFront, colorBack) = colorsFor (toFloat position.y)
            in
            ({model|
                width=width,
                colorFront=colorFront,
                colorBack=colorBack
            }, Cmd.none)
        
subscriptions model =
    Mouse.moves MouseMsg

view model =
    WebGL.toHtml [width 400, height 400]
        (   (quad 1 model.colorBack) 
        ++  (quad model.width model.colorFront) 
        )
    

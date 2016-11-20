module P_2_0_01 exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (..)
import Mouse

type alias Model =
    { resolution: Float
    , radius: Float    
    , stroke: Float
    , offsetLeft: Int
    , offsetTop: Int
    }
    
type Msg = MouseMsg Mouse.Position

init: Int -> Int -> Model
init offsetLeft offsetTop=
    (Model 100 100 5 offsetLeft offsetTop)

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of 
        MouseMsg position ->
            let
                newRes = (toFloat (position.y + model.offsetTop)) / 400 * 100
                newRad = (toFloat (position.x + model.offsetLeft)) / 2
                newStroke = (toFloat (position.y + model.offsetTop)) / 150
            in
                ( {model|resolution=newRes,radius=newRad,stroke=newStroke}
                , Cmd.none
                )

block: Model -> Int -> Html msg
block model index =
    let 
        findex = toFloat index
        angle = pi * 2 / model.resolution
        x = toString (cos(angle*findex) * model.radius + 200)
        y = toString (sin(angle*findex) * model.radius + 200)
        strokeW = toString model.stroke
    in
        line [x1 "200", y1 "200", x2 x, y2 y, strokeWidth strokeW, stroke "black"] []

getCircle: Model -> List (Html msg)
getCircle model =
    List.map (block model) (List.range 0 (floor model.resolution))

view: Model -> Html msg
view model = 
    svg 
        [width "400", height "400", viewBox "0 0 400 400"]
        (getCircle model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import WebGL exposing (toHtml)

import Quad exposing (..)

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

view model =
    WebGL.toHtml [width 400, height 400]
    (   (quad 1 (1, 0, 0)) 
    ++  (quad 0.3 (1, 1, 0)) 
    )
    

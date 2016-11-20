import Html exposing (..)
import Html.Attributes exposing (..)
import Mouse
import Navigation exposing (..)

import P_1_0 exposing (..)
import P_2_0_01 exposing (..)

type alias Model = 
    { example: Example
    , p1: P_1_0.Model   
    , p2: P_2_0_01.Model 
    }

type Msg 
    = MouseMsg Mouse.Position
    | UrlChange Navigation.Location
    | NoOp 
    
type Example 
    = None 
    | P_1_0
    | P_2_0_01

init : Location -> (Model, Cmd Msg)
init location = 
    (
        { example=(exampleForLocation location)
        , p1=P_1_0.init 10 100
        , p2=P_2_0_01.init 10 100
        }
    , Cmd.none
    )

main : Program Never Model Msg
main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , subscriptions = subscriptions
    , update = update 
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ({model|example=(exampleForLocation location)}, Cmd.none)
        MouseMsg pos ->            
            case model.example of
                None ->
                    (model, Cmd.none)
                P_1_0 ->
                    let 
                        (updateModel, updateCmd) = 
                            P_1_0.update (P_1_0.MouseMsg pos) model.p1
                    in
                        ({model|p1=updateModel}, updateCmd)
                P_2_0_01 ->
                    let 
                        (updateModel, updateCmd) =
                            P_2_0_01.update (P_2_0_01.MouseMsg pos) model.p2
                    in 
                        ({model|p2=updateModel}, updateCmd)
        NoOp ->
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch 
        [ Mouse.moves MouseMsg
        ]
    
exampleForLocation : Location -> Example
exampleForLocation location =
    case location.hash of
        "#P1" ->
            P_1_0
        "#P_2_0_01" ->
            P_2_0_01
        _ ->
            None

view : Model -> Html Msg
view model =
    let
        ex = 
            case model.example of
                None ->
                    div [class "placeholder"] [text "Select an example"]
                P_1_0 ->
                    P_1_0.view model.p1
                P_2_0_01 ->
                    P_2_0_01.view model.p2
    in                    
        div [class "mainflex"] 
            [ div [class "row-top"] 
                [ a [ href "#P1" ] 
                    [ img [ (src "static/img/1.0.png")] [] ]
                , a [ href "#P_2_0_01" ] 
                    [ img [ (src "static/img/P_2_0_01.png")] [] ]
                ]  
            , div [class "row-bottom"] [ ex ]
            ]
        
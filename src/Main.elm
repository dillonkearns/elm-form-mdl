module Main exposing (main)

import Html exposing (..)


type Msg
    = NoOp


type alias Model =
    { name : String
    }


view : Model -> Html Msg
view model =
    div []
        [ text "hello" ]


init : ( Model, Cmd Msg )
init =
    { name = ""
    }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

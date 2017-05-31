module Main exposing (main)

import Form exposing (Form)
import Form.Input as Input
import Form.Material
import Form.Validate exposing (Validation)
import Html exposing (..)
import Html.Attributes
import Material
import Material.Options
import Material.Scheme
import Material.Textfield


type Msg
    = NoOp
    | FormMsg Form.Msg
    | MdlMsg (Material.Msg Msg)


type alias UserForm =
    { name : String
    }


type alias Model =
    { form : Form () UserForm
    , mdl : Material.Model
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "hello" ]
        , Html.map FormMsg (formView model.form)
        , Form.Material.textThingy model MdlMsg
        ]


errorFor : { b | liveError : Maybe a } -> Html msg
errorFor field =
    case field.liveError of
        Just error ->
            -- replace toString with your own translations
            div [ Html.Attributes.style [ ( "color", "red" ) ] ] [ text (toString error) ]

        Nothing ->
            text ""


formView : Form () UserForm -> Html Form.Msg
formView form =
    let
        nameField =
            Form.getFieldAsString "name" form
    in
    Html.form []
        [ Input.textInput nameField []
        , errorFor nameField
        ]


init : ( Model, Cmd Msg )
init =
    { form = Form.initial [] userFormValidation
    , mdl = Material.model
    }
        ! []


userFormValidation : Validation () UserForm
userFormValidation =
    Form.Validate.map UserForm (Form.Validate.field "name" Form.Validate.email)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        FormMsg formMsg ->
            ( { model | form = Form.update userFormValidation formMsg model.form }, Cmd.none )

        MdlMsg message_ ->
            Material.update MdlMsg message_ model


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view >> Material.Scheme.top
        }

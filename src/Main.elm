module Main exposing (main)

import Form exposing (FieldState, Form)
import Form.Field
import Form.Material
import Form.Validate exposing (Validation)
import Html exposing (..)
import Material
import Material.Options as Options
import Material.Scheme
import Material.Textfield exposing (error)


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
    let
        nameField =
            Form.getFieldAsString "name" model.form
    in
    div []
        [ h1 [] [ text "hello" ]
        , Form.Material.textThingy [ 0 ]
            model.mdl
            MdlMsg
            FormMsg
            nameField
            [ Options.css "width" "16rem"
            , Material.Textfield.label "Enter email"
            , Material.Textfield.floatingLabel
            ]
        ]


init : ( Model, Cmd Msg )
init =
    { form = Form.initial [] userFormValidation
    , mdl = Material.model
    }
        ! []


userFormValidation : Validation () UserForm
userFormValidation =
    Form.Validate.map UserForm
        (Form.Validate.field "name"
            (Form.Validate.oneOf
                [ Form.Validate.emptyString
                , Form.Validate.email
                ]
            )
        )


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

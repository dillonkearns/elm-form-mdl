module Main exposing (main)

import Form exposing (FieldState, Form)
import Form.Material
import Form.Validate exposing (Validation)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Material
import Material.Button as Button
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
    , submittedUser : Maybe UserForm
    }


view : Model -> Html Msg
view model =
    let
        nameField =
            Form.getFieldAsString "name" model.form
    in
    div []
        [ h1 [] [ text "hello" ]
        , Form.Material.textfield [ 0 ]
            model.mdl
            MdlMsg
            FormMsg
            nameField
            [ Options.css "width" "16rem"
            , Material.Textfield.label "Enter email"
            , Material.Textfield.floatingLabel
            ]
        , Form.Material.submitButton FormMsg
            MdlMsg
            [ 0 ]
            model.mdl
            [ Button.ripple, Button.colored, Button.raised ]
            [ text "Submit" ]
        , submittedUser model
        ]


submittedUser model =
    div [] [ text (toString model.submittedUser) ]


init : ( Model, Cmd Msg )
init =
    { form = Form.initial [] userFormValidation
    , mdl = Material.model
    , submittedUser = Nothing
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
            case ( formMsg, Form.getOutput model.form ) of
                ( Form.Submit, Just user ) ->
                    let
                        _ =
                            Debug.log "Submit success!" user
                    in
                    ( { model | form = Form.update userFormValidation formMsg model.form, submittedUser = Just user }, Cmd.none )

                _ ->
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

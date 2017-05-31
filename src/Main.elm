module Main exposing (main)

import Form exposing (FieldState, Form)
import Form.Material
import Form.Validate exposing (Validation)
import Html exposing (..)
import Html.Events exposing (onSubmit)
import Material
import Material.Button as Button
import Material.Color
import Material.Options as Options
import Material.Scheme
import Material.Textfield exposing (error)


type Msg
    = NoOp
    | FormMsg Form.Msg
    | MdlMsg (Material.Msg Msg)


type alias UserForm =
    { initials : String
    , email : String
    }


type alias Model =
    { form : Form () UserForm
    , mdl : Material.Model
    , submittedUser : Maybe UserForm
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Material Forms" ]
        , formView model
        , submittedUserView model
        ]


formView model =
    let
        initialsField =
            Form.getFieldAsString "initials" model.form

        emailField =
            Form.getFieldAsString "email" model.form
    in
    form [ onSubmit (FormMsg Form.Submit) ]
        [ div []
            [ textfield
                model.mdl
                initialsField
                [ Options.css "width" "16rem"
                , Material.Textfield.label "Enter initals"
                , Material.Textfield.floatingLabel
                ]
            ]
        , div []
            [ textfield
                model.mdl
                emailField
                [ Options.css "width" "16rem"
                , Material.Textfield.label "Enter email"
                , Material.Textfield.floatingLabel
                ]
            ]
        , submitButtonView model.mdl
        ]


submitButtonView mdl =
    Form.Material.submitButton FormMsg
        MdlMsg
        mdl
        [ Button.ripple
        , Button.colored
        , Button.raised
        ]
        [ text "Submit" ]


textfield =
    Form.Material.textfield FormMsg MdlMsg Form.Material.basicErrorToString


submittedUserView model =
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
    Form.Validate.succeed UserForm
        |> Form.Validate.andMap
            (Form.Validate.field "initials"
                (Form.Validate.string |> Form.Validate.andThen (Form.Validate.maxLength 3))
            )
        |> Form.Validate.andMap
            (Form.Validate.field "email"
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
        , view = view >> Material.Scheme.topWithScheme Material.Color.Teal Material.Color.Red
        }

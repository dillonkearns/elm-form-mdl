module Form.Material exposing (textThingy)

import Form exposing (Form)
import Form.Field
import Material.Options as Options
import Material.Textfield exposing (error)


-- textThingy :  -> Html Msg


textThingy { mdl } mdlMsg formMsg field =
    Material.Textfield.render mdlMsg
        [ 0 ]
        mdl
        [ Options.css "width" "16rem"
        , Material.Textfield.label "Enter email"
        , Material.Textfield.floatingLabel
        , Material.Textfield.value (Maybe.withDefault "" field.value)
        , onMaterialInput formMsg field.path
        , onMaterialFocus formMsg field.path
        , onMaterialBlur formMsg field.path
        , Material.Textfield.error (errorMessage field.liveError)
            |> Options.when (field.liveError /= Nothing)
        ]
        []


errorMessage : Maybe a -> String
errorMessage maybeError =
    case maybeError of
        Just error ->
            toString error

        Nothing ->
            ""


onMaterialInput : (Form.Msg -> msg) -> String -> Options.Property c msg
onMaterialInput msg path =
    Options.onInput <| msg << Form.Input path Form.Text << Form.Field.String


onMaterialFocus : (Form.Msg -> msg) -> String -> Options.Property c msg
onMaterialFocus msg path =
    Options.onFocus << msg <| Form.Focus path


onMaterialBlur : (Form.Msg -> msg) -> String -> Options.Property c msg
onMaterialBlur msg path =
    Options.onBlur << msg <| Form.Blur path

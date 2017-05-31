module Form.Material exposing (textfield)

import Form exposing (FieldState, Form)
import Form.Error exposing (ErrorValue)
import Form.Field
import Html
import Material
import Material.Options as Options
import Material.Textfield exposing (error)


-- -> List (Options.Property (Material.Textfield.Config msg) msg)
-- textfield :
--     List Int
--     -> Material.Model
--     -> (Material.Msg msg -> msg)
--     -> (Form.Msg -> msg)
--     -> FieldState e String
--     -> List (Options.Property a msg)
--     -> Html.Html msg


textfield ids mdl mdlMsg formMsg field options =
    let
        something =
            [ Material.Textfield.value (Maybe.withDefault "" field.value)
            , onMaterialInput formMsg field.path
            , onMaterialFocus formMsg field.path
            , onMaterialBlur formMsg field.path
            , Material.Textfield.error (errorMessage field.liveError)
                |> Options.when (field.liveError /= Nothing)
            ]
    in
    Material.Textfield.render mdlMsg
        ids
        mdl
        (options ++ something)
        []



-- errorMessage : Maybe (ErrorValue String) -> String


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

module Form.Material exposing (submitButton, textfield)

-- import Form.Error exposing (ErrorValue)
-- import Html
-- import Material

import Form exposing (FieldState, Form)
import Form.Field
import Hash
import Material.Button as Button
import Material.Options as Options
import Material.Textfield exposing (error)


submitButton formMsg mdlMsg mdlModel options children =
    Button.render mdlMsg
        [ Hash.hash "submit" ]
        mdlModel
        ([ Options.onClick (formMsg Form.Submit), Button.type_ "submit" ] ++ options)
        children



-- -> List (Options.Property (Material.Textfield.Config msg) msg)
-- textfield :
--     (Form.Msg -> msg)
--     -> (Material.Msg msg -> msg)
--     -> Material.Model
--     -> FieldState e String
--     -- -> List (Options.Property (Material.Textfield.Config msg) msg)
--     -> List (Options.Property a msg)
--     -> Html.Html msg


textfield formMsg mdlMsg mdlModel field options =
    let
        validationOptions =
            [ Material.Textfield.value (Maybe.withDefault "" field.value)
            , onMaterialInput formMsg field.path
            , onMaterialFocus formMsg field.path
            , onMaterialBlur formMsg field.path
            , Material.Textfield.error (errorMessage field.liveError)
                |> Options.when (field.liveError /= Nothing)
            ]
    in
    Material.Textfield.render mdlMsg
        [ Hash.hash field.path ]
        mdlModel
        (options ++ validationOptions)
        []



-- errorMessage : Maybe (ErrorValue String) -> String


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

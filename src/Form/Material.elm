module Form.Material exposing (basicErrorToString, submitButton, textfield)

-- import Form.Error exposing (ErrorValue)
-- import Html
-- import Material

import Form exposing (FieldState, Form)
import Form.Error exposing (ErrorValue)
import Form.Field
import Hash
import Html
import Material
import Material.Button as Button
import Material.Options as Options
import Material.Textfield exposing (error)


-- submitButton :
--     (Form.Msg -> msg)
--     -> (Material.Msg msg -> msg)
--     -> Material.Model
--     -> List (Button.Property msg)
--     -> List (Html.Html msg)
--     -> Html.Html msg


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


textfield formMsg mdlMsg errorToString mdlModel field options =
    Material.Textfield.render mdlMsg
        [ Hash.hash field.path ]
        mdlModel
        (options ++ validationOptions formMsg errorToString field)
        []



-- validationOptions :
--     (Form.Msg -> msg)
--     -> (Maybe (ErrorValue String) -> String)
--     -> FieldState e String
--     -> List (Options.Property (Material.Textfield.Config msg) msg)


validationOptions formMsg errorToString field =
    [ Material.Textfield.value (Maybe.withDefault "" field.value)
    , onMaterialInput formMsg field.path
    , onMaterialFocus formMsg field.path
    , onMaterialBlur formMsg field.path
    , Material.Textfield.error (errorToString field.liveError)
        |> Options.when (field.liveError /= Nothing)
    ]


{-| Calls toString on
[Form.Error.ErrorValue](http://package.elm-lang.org/packages/etaque/elm-form/2.0.0/Form-Error#ErrorValue) union type
to get an error message. Best to replace this for production applications with a custom function.
-}



-- basicErrorToString : Maybe (ErrorValue String) -> String


basicErrorToString maybeError =
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

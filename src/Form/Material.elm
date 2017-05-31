module Form.Material exposing (textThingy)

import Form exposing (Form)
import Form.Input as Input
import Form.Validate exposing (Validation)
import Material
import Material.Options as Options
import Material.Textfield


-- textThingy :  -> Html Msg


textThingy { mdl } mdlMsg =
    Material.Textfield.render mdlMsg
        [ 0 ]
        mdl
        [ Options.css "width" "16rem"
        , Material.Textfield.label "Enter email"
        , Material.Textfield.floatingLabel

        -- , Options.onInput NameChanged
        ]
        []

module Example exposing (..)

import Expect exposing (Expectation)
import Form.Error
import Form.Field as Field
import Form.Validate as Validate exposing (Validation, string)
import Test exposing (..)


suite : Test
suite =
    describe "validations"
        [ test "validation" <|
            \() ->
                Ok "Hello"
                    |> Expect.equal
                        (run string)
        ]


run : Validation e a -> Result (Form.Error.Error e) a
run validation =
    Field.group [ ( "fieldKey", Field.string "Hello" ) ]
        |> Validate.field "fieldKey" validation

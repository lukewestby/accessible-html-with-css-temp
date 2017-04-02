module Html.A11y
    exposing
        ( Input
        , textInput
        , radioInput
        , checkboxInput
        , leftLabeledInput
        , rightLabeledInput
        , invisibleLabeledInput
        , tabList
        , tab
        , tabPanel
        , img
        , decorativeImg
        )

{-|
## Inputs
@docs Input
@docs textInput, radioInput, checkboxInput
@docs leftLabeledInput, rightLabeledInput, invisibleLabeledInput

## Tabs
@docs tabList, tab, tabPanel

## Images
@docs img, decorativeImg
-}

import Json.Encode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.A11y as A11y exposing (..)
import Maybe.Extra


{-| Describes the model used in input views in this library.
-}
type alias Input msg =
    { label : Html msg
    , typeAndValue : InputTypeAndValue
    , attributes : List (Html.Attribute msg)
    }


{-| Use helpers like `textInput` and `radioInput` to create InputTypeAndValue items.
-}
type InputTypeAndValue
    = Text String
    | Radio String String Bool
    | Checkbox String (Maybe Bool)


{-| This will construct a text input with the value passed in.

    textInput "This appears in the text input."
-}
textInput : String -> InputTypeAndValue
textInput =
    Text


{-| This will construct a radio input. The first argument is the radio group name
in common across radio items. THe second argument is the value of the radio.
The third is whether the radio is checked or not.

    radioInput "radio_name" "This is the actual value of the radio." True
-}
radioInput : String -> String -> Bool -> InputTypeAndValue
radioInput =
    Radio


{-| This will construct a checkbox input. THe first argument is the value of the checkbox.
The second is whether the radio is checked, unchecked, or indeterminate.

    checkboxInput "radio_name" "This is the actual value of the radio." True
-}
checkboxInput : String -> Maybe Bool -> InputTypeAndValue
checkboxInput =
    Checkbox


indeterminate : Html.Attribute msg
indeterminate =
    property "indeterminate" (Json.Encode.bool True)


typeAndValueAttibutes : InputTypeAndValue -> List (Html.Attribute msg)
typeAndValueAttibutes typeAndValue =
    case typeAndValue of
        Text value_ ->
            [ type_ "text", value value_ ]

        Radio name_ value_ checked_ ->
            [ type_ "radio", name name_, value value_, checked checked_ ]

        Checkbox value_ maybe_checked ->
            [ type_ "checkbox", value value_, Maybe.Extra.unwrap indeterminate checked maybe_checked ]


baseInput : Input msg -> Html msg
baseInput inputModel =
    input (typeAndValueAttibutes inputModel.typeAndValue ++ inputModel.attributes) []


{-| Produces a labeled input of a given label type. The label appears on the left side on the input.
-}
leftLabeledInput : Input msg -> Html msg
leftLabeledInput inputModel =
    label
        []
        [ inputModel.label
        , baseInput inputModel
        ]


{-| Produces a labeled input of a given label type. The label appears on the right side on the input.
-}
rightLabeledInput : Input msg -> Html msg
rightLabeledInput inputModel =
    label
        []
        [ baseInput inputModel
        , inputModel.label
        ]


{-| Produces a labeled input of a given label type.
This label is visibly hidden, but is still available for screen readers.
E.g., use this input if your design asks that you convey information via placeholders
rather than visible labels.
Requires that you pass an id.
-}
invisibleLabeledInput : Input msg -> String -> Html msg
invisibleLabeledInput inputModel id_ =
    span
        []
        [ label [ invisible, for id_ ] [ inputModel.label ]
        , input
            (typeAndValueAttibutes inputModel.typeAndValue
                ++ id id_
                :: inputModel.attributes
            )
            []
        ]



{- *** Tabs *** -}


{-| Create a tablist. This is the outer container for a list of tabs.
-}
tabList : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tabList attributes children =
    div (role Tablist :: attributes) children


{-| Create a tab. This is the part that you select in order to change panel views.
-}
tab : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tab attributes children =
    div (role Tab :: tabindex 0 :: attributes) children


{-| Create a tab panel.

    tabPanel [] [ h3 [] [ text "Panel Header" ], text "Panel Content" ]
-}
tabPanel : List (Html.Attribute msg) -> List (Html msg) -> Html msg
tabPanel attributes children =
    div (role Tabpanel :: attributes) children



{- *** Images *** -}


{-| Use this tag when the image provides information not expressed in the text of the page.
When images are used to express the purpose of a button or link, aim for alternative text that encapsulates the function of the image.

Read through [the w3 informative image tutorial](https://www.w3.org/WAI/tutorials/images/informative/) and the [the w3 functional image tutorial](https://www.w3.org/WAI/tutorials/images/functional/) to learn more.


-}
img : String -> List (Html.Attribute msg) -> Html msg
img alt_ attributes =
    Html.img (alt alt_ :: attributes) []


{-| Use this tag when the image is decorative or provides redundant information. Read through [the w3 decorative image tutorial](https://www.w3.org/WAI/tutorials/images/decorative/) to learn more.
-}
decorativeImg : List (Html.Attribute msg) -> Html msg
decorativeImg attributes =
    Html.img (alt "" :: role Presentation :: attributes) []

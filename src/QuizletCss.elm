module QuizletCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
    = Text


type CssIds
    = Body
    | TextStyle

css =
    (stylesheet << namespace "quizlet")
        [ id TextStyle
            [ color (hex "CCFFFF") ]
        ]

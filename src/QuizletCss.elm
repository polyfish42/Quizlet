module QuizletCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)


type CssClasses
    = Quiz
    | Slide


type CssIds
    = IntroText
    | StartButton
    | ErrorMessageOn
    | SubmitButton
    | ErrorMessage


zeroOut =
    (stylesheet)
        [ each [ html, body, div, span, h1, h2, h3, h4, h5, h6, blockquote, pre, a ]
            [ margin zero
            , padding zero
            , border zero
            , outline zero
            , fontSize (pct 100)
            , verticalAlign baseline
            ]
        ]


css =
    (stylesheet << namespace "quizlet")
        [ class Quiz
            [ width (px 700)
            , height (px 400)
            , margin zero
            , backgroundImage (url "https://www.goodhire.com/hubfs/Q2_DG_ComplianceQuiz_Background.jpeg")
            , position relative
            , descendants
                [ div
                    [ important (fontFamilies [ "Source Sans Pro" ])
                    ]
                , p
                    [ important (color (rgb 255 255 255))
                    , important (fontSize (px 30))
                    , textAlign center
                    , padding4 (px 30) (px 10) (px 0) (px 10)
                    , width (px 680)
                    , position absolute
                    ]
                , button
                    [ position absolute
                    , fontSize (px 24)
                    , color (rgb 255 255 255)
                    , backgroundColor (rgb 130 193 73)
                    , border3 (px 1) solid (rgb 255 255 255)
                    , borderRadius (px 5)
                    , width (px 320)
                    , height (px 70)
                    , cursor pointer
                    , focus [ outline zero ]
                    , transform (translate2 zero (px 45))
                    ]
                , input
                    [ display inlineBlock
                    , width (px 300)
                    , height (px 34)
                    , marginRight (px 15)
                    , padding2 (px 6) (px 12)
                    , fontSize (px 14)
                    , color (hex "#555")
                    , backgroundColor (hex "#ffffff")
                    , border3 (px 1) solid (hex "#ccc")
                    , borderRadius (px 4)
                    , transform (translate2 (px 15) (px 180))
                    , important (boxSizing contentBox)
                    ]
                , select
                    [ display block
                    , fontSize (px 17)
                    , appearance "none"
                    , padding (px 10)
                    , transform (translate2 (px 15) (px 190))
                    , width (px 510)
                    , fontWeight normal
                    ]
                ]
            ]
        , id IntroText
            [ padding4 (px 80) (px 10) (px 0) (px 10) ]
        , class Slide
            [ height (px 115) ]
        , id StartButton
            [ transform (translate2 (px 190) (px 200)) ]
        , id "choice1"
            [ transform (translate2 (px 25) (px 225)) ]
        , id "choice2"
            [ transform (translate2 (px 355) (px 225)) ]
        , id "choice3"
            [ transform (translate2 (px 25) (px 305)) ]
        , id "choice4"
            [ transform (translate2 (px 355) (px 305)) ]
        , id SubmitButton
            [ position absolute
            , transform (translate2 (px 165) (px 205))
            ]
        , id ErrorMessage
            [ important (fontSize (px 17))
            , textAlign center
            , width (px 670)
            , height (px 30)
            , margin4 zero zero zero (px 15)
            , transform (translate2 zero (px 150))
            , padding zero
            , visibility "hidden"
            ]
        , id ErrorMessageOn
            [ backgroundColor (hex "#FF4136")
            , important (visibility "visible")
            , important (fontSize (px 17))
            , textAlign center
            , width (px 670)
            , height (px 30)
            , margin4 zero zero zero (px 15)
            , transform (translate2 zero (px 150))
            , padding zero
            ]
        ]


visibility : String -> Mixin
visibility value =
    property "visibility" value


appearance : String -> Mixin
appearance value =
    mixin
        [ property "-moz-appearance" value
        , property "-webkit-appearance" value
        , property "appearance" value
        ]

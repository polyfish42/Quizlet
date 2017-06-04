port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import QuizletCss


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    Css.File.toFileStructure
        [ ( "stylesheet.css", Css.File.compile [ QuizletCss.css, QuizletCss.zeroOut ] ) ]


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure

module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Quizlet exposing (totalScore)


all : Test
all =
    describe "Quizlet Functions Tests"
        [ fuzz int "Calculates Score" <|
            \num ->
                let
                    score =
                        num
                in
                    Expect.equal (totalScore score) (num + 20)
        ]

module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import Navigation
import String
import Quizlet exposing (totalScore, onBlacklist)


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
        , test "Validate ones are a blacklisted email" <|
            \() ->
                [ "test@outlook.com", "gmail@gmail.com", "yahoo.com", "inbox.com", "@me.com", "mail.net", "aol.com", "hotmail.com" ]
                    |> List.map onBlacklist
                    |> Expect.equal [ True, True, True, True, True, False, True, True ]
        ]

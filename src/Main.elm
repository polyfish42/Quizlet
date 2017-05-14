port module Main exposing (..)

import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = \_ -> Sub.none, view = view }

-- MODEL

type alias Model =
    { introScreen : String
    , history : History
    , scoreScreen : ScoreScreen
    , endScreen : String
    }


type History
    = History
        { previousQuestions : List Question
        , currentQuestion : Question
        , nextQuestions : List Question
        }


type alias Question =
    { question : String
    , choices : Choices
    }


type alias Choices =
    { correct : String
    , wrong : List String
    }


type alias ScoreScreen =
    { text : String
    , formfields : List String
    , dropdowns : List Dropdown
    }


type alias Dropdown =
    { placeholder : String
    , options : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { introScreen = "Hello and welcome to my quiz"
      , history = initQuestions
      , scoreScreen = initScoreScreen
      , endScreen = "Hello"
      }
    , Cmd.none
    )


initQuestions : History
initQuestions =
    History
        { previousQuestions = []
        , currentQuestion =
            { question = "It's illegal to look at a candidate's social media accounts during the hiring process"
            , choices =
                { correct = "False"
                , wrong = [ "True" ]
                }
            }
        , nextQuestions =
            [ { question = "The ban-the-box movement's main goal is to remove what from the hiring process?"
              , choices =
                    { correct = "Criminal-record checkbox on applications"
                    , wrong =
                        [ "Interview questions about convictions"
                        , "All of the above"
                        , "Background checks"
                        ]
                    }
              }
            , { question =
                    "Adverse action notices are legally required when you decide not to hire someone because of a background check. "
                        ++ "Who faces legal repercussions if the notices aren't delivered to the candidate?"
              , choices =
                    { correct = "The employer"
                    , wrong =
                        [ "The job candidate"
                        , "The data provider"
                        , "The CRA"
                        ]
                    }
              }
            , { question =
                    "According to the FCRA, a background check company may report criminal convictions "
                        ++ "for people applying for positions that pay $75,000/year or more for how long?"
              , choices =
                    { correct = "Unlimited"
                    , wrong =
                        [ "7 years"
                        , "5 years"
                        , "12 years"
                        ]
                    }
              }
            , { question = "The FCRA does not apply if you have job candidates pay to run a background check on themselves and show you the results."
              , choices =
                    { correct = "False"
                    , wrong = [ "True" ]
                    }
              }
            ]
        }


initScoreScreen : ScoreScreen
initScoreScreen =
    { text = "You got 100% correct. Enter your work email to get the detailed answer guide."
    , formfields = [ "Work Email", "Name" ]
    , dropdowns =
        [ { placeholder = "How many background checks will you run this year?"
          , options =
                [ "1 - 10 per year"
                , "10 - 25 per year"
                , "25 - 150 per year"
                , "150 - 500 per year"
                , "500 - 1500 per year"
                , "1500 - 2500 per year"
                , "Over 2500 per year"
                ]
          }
        ]
    }

-- UPDATE

type Msg = NoOp

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  p [] [text "Your app has compiled"]

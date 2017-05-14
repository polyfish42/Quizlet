port module Main exposing (..)


type alias Model =
    { introScreen : String
    , previousQuestions : List Question
    , currentQuestion : Question
    , nextQuestions : List Question
    , scoreScreen : ScoreScreen
    , endScreen : String
    }


type alias Question =
    { text : String
    , choices : Choices
    }


type alias Choices =
    { correct : String
    , incorrect : List String
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

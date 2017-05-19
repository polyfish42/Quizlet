port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (value)


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = \_ -> Sub.none, view = view }



-- MODEL


type alias Model =
    { screens : List Screen
    , score : Int
    }


type Screen
    = Intro String
    | Question ( String, List Choice )
    | Results Form
    | End String


type Choice
    = Correct String
    | Wrong String


type alias Form =
    { resultMessageParts : ( String, String )
    , formfields : List String
    , dropdowns : List Dropdown
    }


type alias Dropdown =
    { placeholder : String
    , options : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { screens = intro :: questions ++ results :: end :: []
      , score = 0
      }
    , Cmd.none
    )


intro : Screen
intro =
    Intro "Think you know the rules? Find out now!"


questions : List Screen
questions =
    [ Question
        ( "It's illegal to look at a candidate's social media accounts during the hiring process"
        , [ Wrong "True"
          , Correct "False"
          ]
        )
    , Question
        ( "The ban-the-box movement's main goal is to remove what from the hiring process?"
        , [ Wrong "Interview questions about convictions"
          , Correct "Criminal-record checkbox on applications"
          , Wrong "Background checks"
          , Wrong "All of the above"
          ]
        )
    , Question
        ( "Adverse action notices are legally required when you decide not to hire someone "
            ++ "because of a background check. Who faces legal repercussions if the notices "
            ++ "aren't delivered to the candidate?"
        , [ Wrong "The job candidate"
          , Wrong "The data provider"
          , Wrong "The CRA"
          , Correct "The employer"
          ]
        )
    , Question
        ( "According to the FCRA, a background check company may report criminal convictions "
            ++ "for people applying for positions that pay $75,000/year or more for how long?"
        , [ Wrong "5 years"
          , Wrong "7 years"
          , Wrong "12 years"
          , Correct "Unlimited"
          ]
        )
    , Question
        ( "The FCRA does not apply if you have job candidates pay to run a background check on "
            ++ "themselves and show you the results."
        , [ Wrong "True"
          , Correct "False"
          ]
        )
    ]


results : Screen
results =
    Results
        { resultMessageParts = ( "You got ", "% correct. Enter your work email to get the detailed answer guide." )
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


end : Screen
end =
    End "Thank you! Please check your email to see your answers."



-- UPDATE


type Msg
    = NextScreen
    | AnsweredCorrect
    | AnsweredWrong


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextScreen ->
            ( { model | screens = List.drop 1 model.screens }, Cmd.none )

        AnsweredCorrect ->
            ( { model
                | score = totalScore model
                , screens = List.drop 1 model.screens
              }
            , Cmd.none
            )

        AnsweredWrong ->
            ( { model | screens = List.drop 1 model.screens }, Cmd.none )


totalScore : Model -> Int
totalScore model =
    model.score + (100 // List.length questions)



-- VIEW


view : Model -> Html Msg
view model =
    case currentScreen model.screens of
        Intro str ->
            viewIntro str

        Question ( question, choices ) ->
            viewQuestion question choices

        Results { resultMessageParts, formfields, dropdowns } ->
            viewResults model resultMessageParts formfields dropdowns

        End str ->
            p [] [ text str ]


currentScreen : List Screen -> Screen
currentScreen screenList =
    case List.head screenList of
        Just screen ->
            screen

        Nothing ->
            end


viewIntro : String -> Html Msg
viewIntro str =
    div []
        [ p [] [ text str ]
        , button [ onClick NextScreen ] [ text "GET STARTED" ]
        ]


viewQuestion : String -> List Choice -> Html Msg
viewQuestion question choices =
    div [] <|
        [ p [] [ text question ] ]
            ++ List.map viewChoice choices


viewChoice : Choice -> Html Msg
viewChoice choice =
    case choice of
        Correct str ->
            button [ onClick AnsweredCorrect ] [ text str ]

        Wrong str ->
            button [ onClick AnsweredWrong ] [ text str ]


viewResults : Model -> ( String, String ) -> List String -> List a -> Html Msg
viewResults model ( messageStart, messageEnd ) formfields dropdowns =
    div []
        [ p [] [ text <| messageStart ++ toString model.score ++ messageEnd ]
        , viewForm formfields
        ]


viewForm : List String -> Html Msg
viewForm fields =
    let
        viewInput field =
            input [ value (toString field) ] []
    in
        form [] <|
            List.map viewInput fields
                ++ [ button [ onClick NextScreen ] [ text "Submit" ] ]


viewEnd : String -> Html Msg
viewEnd str =
    div []
        [ p [] [ text str ] ]

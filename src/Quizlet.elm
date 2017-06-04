port module Quizlet exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style, value, disabled, selected, action, placeholder, attribute)
import Html.CssHelpers exposing (withNamespace)
import Http
import QuizletCss exposing (..)
import Json.Decode
import Json.Encode as E
import Task
import Window


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }


stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "stylesheet.css"
            ]

        children =
            []
    in
        node tag attrs children



-- MODEL


type alias Model =
    { screens : List Screen
    , score : Int
    , name : String
    , workEmail : String
    , expectedChecksPerYear : String
    , error : Maybe String
    , cookie : String
    , quizSize : Float
    , ipAddress : String
    }


type Screen
    = Intro
    | Question ( String, List Choice )
    | Results
    | End


type Choice
    = Correct String
    | Wrong String


init : ( Model, Cmd Msg )
init =
    ( { screens = Intro :: questions ++ Results :: End :: []
      , score = 0
      , expectedChecksPerYear = ""
      , name = ""
      , workEmail = ""
      , error = Nothing
      , cookie = ""
      , quizSize = 1
      , ipAddress = ""
      }
    , Cmd.batch [ (getCookie "hubspotutk"), (Task.perform Resize Window.width) ]
    )


port getCookie : String -> Cmd msg


getIpAddress : Cmd Msg
getIpAddress =
    Http.send IpAddressResponse <|
        Http.get "http://freegeoip.net/json/" (Json.Decode.field "ip" Json.Decode.string)


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



-- UPDATE


type Msg
    = Resize Int
    | Cookie String
    | IpAddressResponse (Result Http.Error String)
    | NextScreen
    | AnsweredCorrect
    | Name String
    | WorkEmail String
    | ExpectedChecksPerYear String
    | EmailError
    | Submit
    | HubspotResponse (Result Http.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize int ->
            ( { model
                | quizSize =
                    if int < 700 then
                        (toFloat int) / 700
                    else
                        1
              }
            , Cmd.none
            )

        Cookie str ->
            ( { model | cookie = str }, Cmd.none )

        IpAddressResponse (Ok str) ->
            ( { model | ipAddress = str }, Cmd.none )

        IpAddressResponse (Err _) ->
            ( model, Cmd.none )

        NextScreen ->
            ( { model | screens = List.drop 1 model.screens }, Cmd.none )

        AnsweredCorrect ->
            ( { model
                | score = totalScore model.score
                , screens = List.drop 1 model.screens
              }
            , Cmd.none
            )

        Name str ->
            ( { model | name = str }, Cmd.none )

        WorkEmail str ->
            ( { model | workEmail = str }, Cmd.none )

        ExpectedChecksPerYear opt ->
            ( { model | expectedChecksPerYear = opt }, Cmd.none )

        EmailError ->
            ( { model | error = Just "Please enter your work email." }, Cmd.none )

        Submit ->
            ( model, submitForm model )

        HubspotResponse (Ok str) ->
            ( { model | screens = List.drop 1 model.screens }, Cmd.none )

        HubspotResponse (Err _) ->
            ( { model | error = Just "There's been an error, please try again later." }, Cmd.none )


totalScore : Int -> Int
totalScore score =
    score + (100 // List.length questions)


submitForm : Model -> Cmd Msg
submitForm model =
    Http.send HubspotResponse <|
        hubspotRequest model


hubspotRequest : Model -> Http.Request ()
hubspotRequest model =
    Http.request
        { method = "POST"
        , headers = []
        , url = url model
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = False
        }


url : Model -> String
url model =
    "https://forms.hubspot.com/uploads/form/v2/<PORTAL_ID>/<FORM_ID>"
        ++ "?email="
        ++ model.workEmail
        ++ "&firstname="
        ++ (Maybe.withDefault "" <| List.head (String.split " " model.name))
        ++ "&expected_checks_per_year="
        ++ model.expectedChecksPerYear
        ++ "&lead_source_details__c=goodhire.com/compliance-quiz"
        ++ "&hs_context="
        ++ hsContextParam model


hsContextParam : Model -> String
hsContextParam model =
    E.object
        [ ( "hutk", E.string model.cookie )
        , ( "ipaddress", E.string model.ipAddress )
        , ( "pageUrl", E.string "https://www.goodhire.com/compliance-quiz" )
        , ( "pageName", E.string "2017_Q1_DG_ComplianceCampaign_ComplianceQuizLP" )
        , ( "redirectUrl", E.string "https://www.goodhire.com/compliance-quiz" )
        ]
        |> E.encode 0
        |> Http.encodeUri



-- SUBSCRIPTIONS


port hubspotCookie : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ (hubspotCookie Cookie), (Window.resizes (\x -> Resize x.width)) ]



-- VIEW


{ id, class, classList } =
    withNamespace "quizlet"


view : Model -> Html Msg
view model =
    div
        [ id Main
        , style [ ( "transform", quizSize model ), ("transformOrigin", "0px 0px 0px") ]
        ]
        [ stylesheet
        , case currentScreen model.screens of
            Intro ->
                viewIntro

            Question ( question, choices ) ->
                viewQuestion question choices

            Results ->
                viewResults model

            End ->
                viewEnd
        ]


quizSize : Model -> String
quizSize model =
    "scale(" ++ toString model.quizSize ++")"


currentScreen : List Screen -> Screen
currentScreen screenList =
    case List.head screenList of
        Just screen ->
            screen

        Nothing ->
            End



-- Intro


viewIntro : Html Msg
viewIntro =
    div [ class [ Slide ] ]
        [ p [] [ text "Think you know the rules? Find out now!" ]
        , button [ onClick NextScreen, id StartButton ] [ text "GET STARTED" ]
        ]



-- Questions


viewQuestion : String -> List Choice -> Html Msg
viewQuestion question choices =
    div [ class [ Slide ] ] <|
        [ p [] [ text question ] ]
            ++ List.indexedMap viewChoice choices


viewChoice : Int -> Choice -> Html Msg
viewChoice index choice =
    case choice of
        Correct str ->
            button [ onClick AnsweredCorrect, class [ "choice" ++ toString (index + 1) ] ] [ text str ]

        Wrong str ->
            button [ onClick NextScreen, class [ "choice" ++ toString (index + 1) ] ] [ text str ]



-- Results


viewResults : Model -> Html Msg
viewResults model =
    div [ class [ Slide ] ]
        [ p [] [ text <| "You got " ++ toString model.score ++ "% correct. Enter your work email to get the detailed answer guide." ]
        , viewForm model
        ]


viewForm : Model -> Html Msg
viewForm model =
    form [ onSubmit <| validateForm model.workEmail ] <|
        viewError model.error
            ++ [ input [ placeholder "Work Email", onInput WorkEmail ] [] ]
            ++ [ input [ placeholder "Name", onInput Name ] [] ]
            ++ [ select [ onInput ExpectedChecksPerYear ] <| viewDropdown ]
            ++ [ button [ id SubmitButton ] [ text "Submit" ] ]


validateForm : String -> Msg
validateForm email =
    if email == "" then
        EmailError
    else if onBlacklist email then
        EmailError
    else
        Submit


onBlacklist : String -> Bool
onBlacklist email =
    List.map (\x -> String.contains x email) blacklistedEmails |> List.any isTrue


blacklistedEmails : List String
blacklistedEmails =
    [ "outlook.com", "gmail.com", "yahoo.com", "inbox.com", "@me.com", "mail.com", "aol.com", "zoho.com", "yandex.com", "hotmail.com" ]


isTrue : Bool -> Bool
isTrue bool =
    bool == True


viewError : Maybe String -> List (Html Msg)
viewError error =
    case error of
        Just message ->
            [ p [ id ErrorMessageOn, class [ ErrorMessage ] ] [ text message ] ]

        Nothing ->
            [ p [ class [ ErrorMessage ] ] [] ]


viewDropdown : List (Html Msg)
viewDropdown =
    let
        viewOption optionText =
            option [ value optionText ] [ text optionText ]

        options =
            [ "1 - 10 per year"
            , "10 - 25 per year"
            , "25 - 150 per year"
            , "150 - 500 per year"
            , "500 - 1500 per year"
            , "1500 - 2500 per year"
            , "Over 2500 per year"
            ]
    in
        option [ disabled True, selected True ] [ text "- How Many Background Checks Will You Run This Year? -" ]
            :: List.map viewOption options



-- End


viewEnd : Html Msg
viewEnd =
    div [ class [ Slide ] ]
        [ p [] [ text "Thank you! Please check your email to see your answers." ] ]

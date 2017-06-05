# Hubspot Quizlet
This is a compliance quiz that I built as a marketing lead generation tool. Right now it's configured to work for my company's needs, but will a little customization anyone can use it.

## Getting Started
You'll need a few things to get started.
### Prerequisites
```
elm
node.js
elm-test
elm-css
```
### Configuration
In order to submit the information from the quiz to Hubspot, you'll need to first create a form in Hubspot with the same fields as the quiz.

Replace the PORTAL_ID and FORM_ID tags in Quizlet.elm with your Hubspot portal ID and Form Id. You can read how to do that [here](https://knowledge.hubspot.com/articles/kcs_article/forms/how-do-i-find-the-form-guid).

```
url : Model -> String
url model =
    "https://forms.hubspot.com/uploads/form/v2/<PORTAL_ID>/<FORM_ID>"
```

### Compiling for Hubspot
Cd into the root directory. Then:
1. `elm-make src/Quizlet.elm --output=main.js`
2. Host index.html, main.js, and stylesheet.css where ever you like. If you want the quiz on a Hubspot page, you can use an iFrame or [custom module](http://designers.hubspot.com/docs/cos/custom-modules)

## Built With
* [Elm](http://elm-lang.org/)
* [elm-css](https://github.com/rtfeldman/elm-css)
* [elm-test](https://github.com/elm-community/elm-test)

## License
This project is licensed under the Apache License - see the LICENSE.md file for details

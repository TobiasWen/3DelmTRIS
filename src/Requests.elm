module Requests exposing (getScoresCmd, postScoreCmd)

import Http
import Messages exposing (Msg(..))
import Score exposing (Score, scoreEncoder, scoreListDecoder)



-- Commands for interacting with the highscore api.


url : String
url =
    "http://cloud.wentzlaff.com:23000/"



-- Get request command for fetching the highscore list.


getScoresCmd : Cmd Msg
getScoresCmd =
    Http.get
        { url = url ++ "scores/"
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }



-- Post request command for transmitting the achieved score to the api server.


postScoreCmd : Score -> Cmd Msg
postScoreCmd score =
    Http.post
        { url = url ++ "scores/"
        , body = Http.jsonBody <| scoreEncoder score
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }

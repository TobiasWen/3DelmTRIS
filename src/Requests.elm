module Requests exposing (getScoresCmd, postScoreCmd)

import Http
import Messages exposing (Msg(..))
import Score exposing (Score, scoreEncoder, scoreListDecoder)



-- Commands for interacting with the highscore api


url : String
url =
    "http://cloud.wentzlaff.com:23000/"


getScoresCmd : Cmd Msg
getScoresCmd =
    Http.get
        { url = url
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }


postScoreCmd : Score -> Cmd Msg
postScoreCmd score =
    Http.post
        { url = url
        , body = Http.jsonBody <| scoreEncoder score
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }

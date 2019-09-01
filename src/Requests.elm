module Requests exposing (getScoresCmd, postScoreCmd)

import Http
import Messages exposing (Msg(..))
import Score exposing (Score, scoreEncoder, scoreListDecoder)



-- Commands for interacting with the highscore api


getScoresCmd : Cmd Msg
getScoresCmd =
    Http.get
        { url = "http://cloud.wentzlaff.com:23000/"
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }


postScoreCmd : Score -> Cmd Msg
postScoreCmd score =
    Http.post
        { url = "http://cloud.wentzlaff.com:23000/"
        , body = Http.jsonBody <| scoreEncoder score
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }

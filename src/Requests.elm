module Requests exposing (getScoresCmd)

import Http
import Messages exposing (Msg(..))
import Score exposing (scoreListDecoder)



-- Commands for interacting with the highscore api


getScoresCmd : Cmd Msg
getScoresCmd =
    Http.get
        { url = "http://cloud.wentzlaff.com:23000/"
        , expect = Http.expectJson ScoreResponse scoreListDecoder
        }

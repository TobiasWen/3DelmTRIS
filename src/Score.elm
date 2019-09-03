module Score exposing (Score, Scores, ScoresData(..), clearPointsFourPlanes, clearPointsOnePlane, clearPointsThreePlanes, clearPointsTwoPlanes, pointsBlockPlaced, scoreDecoder, scoreEncoder, scoreListDecoder)

import Http
import Json.Decode
import Json.Encode


type ScoresData
    = Loaded Scores
    | Loading
    | Error Http.Error


type alias Score =
    { name : String
    , score : Int
    , rank : Int
    }



-- Record with one field to match json object structure.


type alias Scores =
    { scores : List Score }



{- Score Point constants which are added to the score each time a
   tetroid is placed or a plane is cleared.
-}


clearPointsOnePlane : Int
clearPointsOnePlane =
    1000


clearPointsTwoPlanes : Int
clearPointsTwoPlanes =
    3000


clearPointsThreePlanes : Int
clearPointsThreePlanes =
    5000


clearPointsFourPlanes : Int
clearPointsFourPlanes =
    10000


pointsBlockPlaced : Int
pointsBlockPlaced =
    100



-- Decoders to decode the json received from the highscore api server into elm records.


scoreDecoder : Json.Decode.Decoder Score
scoreDecoder =
    Json.Decode.map3 (\name score rank -> { name = name, score = score, rank = rank })
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "score" Json.Decode.int)
        (Json.Decode.field "rank" Json.Decode.int)


scoreListDecoder : Json.Decode.Decoder Scores
scoreListDecoder =
    Json.Decode.map (\scores -> { scores = scores })
        (Json.Decode.field "scores" <| Json.Decode.list scoreDecoder)



{- Encoder to encode an elm score record into a json object
   for transmitting to the highscore api server.
-}


scoreEncoder : Score -> Json.Encode.Value
scoreEncoder score =
    Json.Encode.object [ ( "name", Json.Encode.string score.name ), ( "score", Json.Encode.int score.score ) ]

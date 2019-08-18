module Update exposing (update)

import Dimensions exposing (WorldDimensions, calculateTopCenter)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Movement exposing (spawnTetroid)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start tetroid ->
            ( { model | upcomingTetroid = Just (spawnTetroid tetroid model.dimensions) }, Cmd.none )

        _ ->
            ( model, Cmd.none )

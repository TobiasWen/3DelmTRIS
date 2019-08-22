module Update exposing (update)

import Dimensions exposing (WorldDimensions, calculateTopCenter)
import Grid exposing (mergeGrids)
import Input exposing (Key(..))
import Messages exposing (Msg(..))
import Model exposing (GameState(..), Model)
import Movement exposing (Direction(..), fallDown, isCollidingWithFloor, moveTetroid, spawnTetroid)
import Random exposing (..)
import Tetroids exposing (Tetroid, tetroidGenerator)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start tetroid ->
            ( startGame model tetroid, Cmd.none )

        Tick ->
            handleTick ( model, Cmd.none )

        UpcomingTetroid tetroid ->
            ( setUpcomingTetroid model tetroid, Cmd.none )

        KeyEvent key ->
            ( handleKeyInput model key, Cmd.none )

        _ ->
            ( model, Cmd.none )


startGame : Model -> Tetroid -> Model
startGame model tetroid =
    { model | upcomingTetroid = Just (spawnTetroid tetroid model.dimensions), gameState = Running }


setUpcomingTetroid : Model -> Tetroid -> Model
setUpcomingTetroid model tetroid =
    { model | upcomingTetroid = Just (spawnTetroid tetroid model.dimensions) }


handleTick : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
handleTick mc =
    checkForNewTetroid mc |> checkForCollision


checkForNewTetroid : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkForNewTetroid ( model, cmd ) =
    if model.activeTetroid == Nothing then
        ( { model | activeTetroid = model.upcomingTetroid }, Cmd.batch [ Random.generate UpcomingTetroid tetroidGenerator, cmd ] )

    else
        ( model, cmd )


checkForCollision : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkForCollision ( model, cmd ) =
    case model.activeTetroid of
        Just tetroid ->
            if isCollidingWithFloor tetroid model.dimensions then
                ( { model | grid = mergeGrids model.grid tetroid.grid, activeTetroid = Nothing }, cmd )

            else
                ( { model | activeTetroid = Just (fallDown tetroid) }, cmd )

        Nothing ->
            ( model, Cmd.none )


handleKeyInput : Model -> Key -> Model
handleKeyInput model key =
    case model.activeTetroid of
        Just tetroid ->
            case key of
                SpaceKeyDown ->
                    { model | fastFallDown = True }

                SpaceKeyUp ->
                    { model | fastFallDown = False }

                ArrowDownKeyDown ->
                    { model | activeTetroid = Just (moveTetroid tetroid Down) }

                ArrowUpKeyDown ->
                    { model | activeTetroid = Just (moveTetroid tetroid Up) }

                ArrowLeftKeyDown ->
                    { model | activeTetroid = Just (moveTetroid tetroid Left) }

                ArrowRightKeyDown ->
                    { model | activeTetroid = Just (moveTetroid tetroid Right) }

                _ ->
                    model

        Nothing ->
            model

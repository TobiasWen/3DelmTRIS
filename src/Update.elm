module Update exposing (update)

import Dimensions exposing (WorldDimensions, calculateTopCenter)
import Grid exposing (Direction(..), Grid, checkGridFallDownCollision, checkGridMovementCollision, checkGridOverlap, clearPlanes, mergeGrids)
import Http
import Input exposing (Key(..), Mouse)
import Messages exposing (Msg(..))
import Model exposing (GameState(..), Model, initialModel)
import Movement exposing (calculateWallKickVector, fallDown, isCollidingWithFloor, moveTetroid, spawnTetroid, translateTetroid)
import Random exposing (..)
import Requests exposing (postScoreCmd)
import Rotation exposing (Axis(..), canRotate, rotateTetroid)
import Score exposing (Scores, ScoresData(..), clearPointsFourPlanes, clearPointsOnePlane, clearPointsThreePlanes, clearPointsTwoPlanes, pointsBlockPlaced, scoreListDecoder)
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

        MouseEvent mouse ->
            ( { model | mousePosition = mouse }, Cmd.none )

        GetWindowsSize windowWidth windowHeight ->
            ( { model
                | windowSize =
                    { width = windowWidth
                    , height = windowHeight
                    }
              }
            , Cmd.none
            )

        ScoreResponse response ->
            handleScoreResponse response ( model, Cmd.none )

        NewName name ->
            ( { model | playerName = name }, Cmd.none )

        SendScore score ->
            case initialModel of
                ( mod, cmd ) ->
                    ( mod, Cmd.batch [ cmd, postScoreCmd score ] )

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
    checkForNewTetroid mc |> checkForCollision |> checkForClear


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
            if checkGridOverlap tetroid.grid model.grid then
                ( { model | gameState = Stopped, gameOver = True }, cmd )

            else if checkGridFallDownCollision tetroid.grid model.grid || isCollidingWithFloor tetroid model.dimensions then
                ( { model | grid = mergeGrids model.grid tetroid.grid, activeTetroid = Nothing, fastFallDown = False, score = model.score + pointsBlockPlaced }, cmd )

            else
                ( { model | activeTetroid = Just (fallDown tetroid) }, cmd )

        Nothing ->
            ( model, cmd )


checkForClear : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkForClear ( model, cmd ) =
    let
        clearedGridAndCount : ( Grid, Int )
        clearedGridAndCount =
            clearPlanes model.grid (round <| model.dimensions.width * model.dimensions.depth) model.dimensions.height
    in
    if model.activeTetroid == Nothing then
        case clearedGridAndCount of
            ( grid, clearedPlaneCount ) ->
                case clearedPlaneCount of
                    1 ->
                        ( { model | grid = grid, score = model.score + clearPointsOnePlane }, cmd )

                    2 ->
                        ( { model | grid = grid, score = model.score + clearPointsTwoPlanes }, cmd )

                    3 ->
                        ( { model | grid = grid, score = model.score + clearPointsThreePlanes }, cmd )

                    4 ->
                        ( { model | grid = grid, score = model.score + clearPointsFourPlanes }, cmd )

                    _ ->
                        ( model, cmd )

    else
        ( model, cmd )


handleScoreResponse : Result Http.Error Scores -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
handleScoreResponse response ( model, cmd ) =
    case response of
        Err error ->
            ( { model | highscores = Error error }, cmd )

        Ok scores ->
            ( { model | highscores = Loaded scores }, cmd )


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
                    if checkGridMovementCollision tetroid.grid model.grid Down then
                        model

                    else
                        { model | activeTetroid = Just (moveTetroid tetroid Down model.dimensions) }

                ArrowUpKeyDown ->
                    if checkGridMovementCollision tetroid.grid model.grid Up then
                        model

                    else
                        { model | activeTetroid = Just (moveTetroid tetroid Up model.dimensions) }

                ArrowLeftKeyDown ->
                    if checkGridMovementCollision tetroid.grid model.grid Left then
                        model

                    else
                        { model | activeTetroid = Just (moveTetroid tetroid Left model.dimensions) }

                ArrowRightKeyDown ->
                    if checkGridMovementCollision tetroid.grid model.grid Right then
                        model

                    else
                        { model | activeTetroid = Just (moveTetroid tetroid Right model.dimensions) }

                QKeyDown ->
                    if canRotate tetroid model.grid X model.dimensions then
                        { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid X) (calculateWallKickVector (rotateTetroid tetroid X) model.dimensions)) }

                    else
                        model

                EKeyDown ->
                    if canRotate tetroid model.grid Y model.dimensions then
                        { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid Y) (calculateWallKickVector (rotateTetroid tetroid Y) model.dimensions)) }

                    else
                        model

                RKeyDown ->
                    if canRotate tetroid model.grid Z model.dimensions then
                        { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid Z) (calculateWallKickVector (rotateTetroid tetroid Z) model.dimensions)) }

                    else
                        model

                _ ->
                    model

        Nothing ->
            model

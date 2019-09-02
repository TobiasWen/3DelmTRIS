module Update exposing (update)

import Grid exposing (Direction(..), Grid, checkGridFallDownCollision, checkGridMovementCollision, checkGridOverlap, clearPlanes, mergeGrids)
import Http
import Input exposing (Key(..))
import Messages exposing (Msg(..))
import Model exposing (GameState(..), Model, initialModel)
import Movement exposing (calculateWallKickVector, fallDown, isCollidingWithFloor, moveTetroid, spawnTetroid, translateTetroid)
import Random exposing (generate)
import Requests exposing (postScoreCmd)
import Rotation exposing (Axis(..), canRotate, rotateTetroid)
import Score exposing (Scores, ScoresData(..), clearPointsFourPlanes, clearPointsOnePlane, clearPointsThreePlanes, clearPointsTwoPlanes, pointsBlockPlaced)
import Sounds exposing (sounds)
import Tetroids exposing (Tetroid, tetroidGenerator)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start tetroid ->
            ( startGame model tetroid, sounds "music" )

        Tick ->
            handleTick ( model, Cmd.none )

        UpcomingTetroid tetroid ->
            ( setUpcomingTetroid model tetroid, Cmd.none )

        KeyEvent key ->
            handleKeyInput model key

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
handleTick ( model, cmd ) =
    if model.gameOver then
        ( model, cmd )

    else
        checkForCollision ( model, cmd ) |> checkForClear


checkForCollision : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
checkForCollision ( model, cmd ) =
    case model.activeTetroid of
        Just tetroid ->
            if checkGridOverlap tetroid.grid model.grid then
                ( { model | gameState = Stopped, gameOver = True }, Cmd.batch [ cmd, sounds "gameOver" ] )

            else if checkGridFallDownCollision tetroid.grid model.grid || isCollidingWithFloor tetroid model.dimensions then
                ( { model | grid = mergeGrids model.grid tetroid.grid, activeTetroid = Nothing, fastFallDown = False, score = model.score + pointsBlockPlaced }, Cmd.batch [ cmd, sounds "tetroidPlaced" ] )

            else
                ( { model | activeTetroid = Just (fallDown tetroid) }, cmd )

        Nothing ->
            ( { model | activeTetroid = model.upcomingTetroid }, Cmd.batch [ Random.generate UpcomingTetroid tetroidGenerator, cmd ] )


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
                        ( { model | grid = grid, score = model.score + clearPointsOnePlane }, Cmd.batch [ cmd, sounds "planeCleared" ] )

                    2 ->
                        ( { model | grid = grid, score = model.score + clearPointsTwoPlanes }, Cmd.batch [ cmd, sounds "planeCleared" ] )

                    3 ->
                        ( { model | grid = grid, score = model.score + clearPointsThreePlanes }, Cmd.batch [ cmd, sounds "planeCleared" ] )

                    4 ->
                        ( { model | grid = grid, score = model.score + clearPointsFourPlanes }, Cmd.batch [ cmd, sounds "planeCleared" ] )

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


handleKeyInput : Model -> Key -> ( Model, Cmd Msg )
handleKeyInput model key =
    if model.gameOver then
        ( model, Cmd.none )

    else
        case model.activeTetroid of
            Just tetroid ->
                case key of
                    SpaceKeyDown ->
                        ( { model | fastFallDown = True }, Cmd.none )

                    SpaceKeyUp ->
                        ( { model | fastFallDown = False }, Cmd.none )

                    EnterKeyDown ->
                        initialModel

                    ArrowDownKeyDown ->
                        if checkGridMovementCollision tetroid.grid model.grid Down then
                            ( model, Cmd.none )

                        else
                            ( { model | activeTetroid = Just (moveTetroid tetroid Down model.dimensions) }, Cmd.none )

                    ArrowUpKeyDown ->
                        if checkGridMovementCollision tetroid.grid model.grid Up then
                            ( model, Cmd.none )

                        else
                            ( { model | activeTetroid = Just (moveTetroid tetroid Up model.dimensions) }, Cmd.none )

                    ArrowLeftKeyDown ->
                        if checkGridMovementCollision tetroid.grid model.grid Left then
                            ( model, Cmd.none )

                        else
                            ( { model | activeTetroid = Just (moveTetroid tetroid Left model.dimensions) }, Cmd.none )

                    ArrowRightKeyDown ->
                        if checkGridMovementCollision tetroid.grid model.grid Right then
                            ( model, Cmd.none )

                        else
                            ( { model | activeTetroid = Just (moveTetroid tetroid Right model.dimensions) }, Cmd.none )

                    QKeyDown ->
                        if canRotate tetroid model.grid X model.dimensions then
                            ( { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid X) (calculateWallKickVector (rotateTetroid tetroid X) model.dimensions)) }, sounds "tetroidRotated" )

                        else
                            ( model, Cmd.none )

                    EKeyDown ->
                        if canRotate tetroid model.grid Y model.dimensions then
                            ( { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid Y) (calculateWallKickVector (rotateTetroid tetroid Y) model.dimensions)) }, sounds "tetroidRotated" )

                        else
                            ( model, Cmd.none )

                    RKeyDown ->
                        if canRotate tetroid model.grid Z model.dimensions then
                            ( { model | activeTetroid = Just (translateTetroid (rotateTetroid tetroid Z) (calculateWallKickVector (rotateTetroid tetroid Z) model.dimensions)) }, sounds "tetroidRotated" )

                        else
                            ( model, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

            Nothing ->
                ( model, Cmd.none )

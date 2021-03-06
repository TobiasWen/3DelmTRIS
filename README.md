![alt text](https://i.gyazo.com/c5e0bf370e6b4f7b6cc3132e5a156476.png "3DelmTRIS logo")
3DelmTRIS is a 3D version of Tetris created with WebGL in the 0.19 release of the elm programming language. This project was created during the university course 'Functional Frontend Development' at the Flensburg University of Applied Sciences.

Play 3DelmTRIS [here](https://tobiaswen.github.io/3DelmTRIS/) or download the newest pre-built version from [here](https://github.com/TobiasWen/3DelmTRIS/releases).
For the best experience use a full hd screen or adjust zoom levels accordingly. A fully responsive design might be added in future releases. Currently only working on Google Chrome.

## Building from source
1. `elm make src/Main.elm --output=dist/main.js`
2. `cd` into dist folder
3. open index.html

## Running tests
The tests in this project were only created for testing functionality in the early stages of the development process and to learn about unit testing in elm. They're nowhere near complete and aren't covering any edge cases etc. At the current stage they're not meant to detect possible defects in a meaningful manner nor do they contribute to an increase in the software quality. Proper testing and CI might be added in the future.

1. Run `npm install -g elm-test` if you haven't already.
2. `cd` into the project's root directory.
3. Run `elm-test`.

## Assets
- Background music by [FreeMusicDownload-NoCopyrightSongs](https://audiograb.com/egPVoqkI).  
- Sound effects taken from [https://freesound.org/](https://freesound.org/).

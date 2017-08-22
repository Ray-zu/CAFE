CAFE
====

CAFE(Creator's Advanced Film Editor)は、AviUtlの後継として考案されたプロジェクトです。

## Description

現在開発中です。

## Demo

## Requirement

### OS

動作確認済みOS

* Windows 10 Home 64bit
* Windows 7 Professional 64bit
* Ubuntu 14.04 LTS (Unity)

### Libraries

#### Windows
* OpenGL
* OpenAL
* SDL2
* freetype

Windowsに於いてはライブラリが同梱されているので別途インストールの必要はありません。

#### Linux
* libopenal-dev
* libsdl2-dev
* freeglut3-dev
* libglew1.5-dev
* [freetype](http://download.savannah.gnu.org/releases/freetype/)

apt-get : `sudo apt-get install libopenal-dev libsdl2-dev freeglut3-dev libglew1.5-dev`  
freetypeは手動でインストールしてください。

#### OS X
* freetype
* openal
* opengl
* sdl2

brew : `brew install freetype; brew install openal; brew install sdl2`

### Compiler and BuildTool

* dmd 2.075.0
* dub 1.0.0

## Build

リリースされているものと同じバイナリを作成するには以下のコマンドを使用します。

    dub build --build=release -a x86_64 --config=mt # マルチスレッド対応
    dub build --build=release -a x86_64             # マルチスレッド非対応

デバッグ用のバイナリは以下のコマンドで作成します。

    dub build

デバッグコンパイルに於いて、マルチスレッドを利用すると正常に動作しません。

## Licence

[GNU Public License v3.0](https://github.com/aoitofu/CAFE/blob/master/LICENSE)

## Author

[aoitofu](https://twitter.com/_aoi_tofu_)  
[Aodaruma](https://twitter.com/Aodaruma_)  
[SEED264](https://twitter.com/SEED264)


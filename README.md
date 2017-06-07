CAFE
====

CAFE(Creator's Advanced Film Editor)は、AviUtlの後継として考案されたプロジェクトです。

## Description

現在開発中です。

## Demo

## Requirement

* dmd
* dub

## Unit Test

    dub test                        # 32bit unittest
    dub test -a x86_64              # 64bit unittest

64bitビルドでは一部の例外がcatchされず異常終了してしまうのでunittestは32bitで行うようにしてください。

## Install

    dub -a x86_64                   # 64bit only

## Licence

[GNU Public License v3.0](https://github.com/aoitofu/CAFE/blob/master/LICENSE)

## Author

[aoitofu](https://twitter.com/_aoi_tofu_)  
[Aodaruma](https://twitter.com/Aodaruma_)  
[SEED264](https://twitter.com/SEED264)


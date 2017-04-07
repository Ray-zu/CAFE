コードスタイルガイド
====

CAFEのソースコードを書く際のスタイルの指定についての解説です。

## ソースファイル

文字コードは全てUTF-8にします。

### 分割

ソースファイルはクラス一つに付き一つを原則とします。  
特殊な場合に於いては個人の判断に委ねます。

### ヘッダ

ソースファイルの先頭には以下の内容のコメントを追加します。

    /+ Copyright (C) 2017 aoitofu / Aodaruma / SEED264
       Author : [担当者]

       This program is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation; either version 3 of the License, or
       (at your option) any later version.

       This program is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with this program.  If not, see <http://www.gnu.org/licenses/>
    +/


## 命名規則

関数/メソッドに対してはキャメルケースを使用します。(`hogeHoge`)  
変数に対してはスネーク記法を使用します。(`hoge_hoge`)  
定数に対してはスネーク記法を使用した大文字にします。(`HOGE_HOGE`)  
クラス/インターフェース/構造体に対してはパスカルケースを使用します。(`HogeHoge`)

命名はなるべく略さないようにします。  
しかし、慣例として例が広く出回っているものは略します。

### ループカウンタ

D言語ではカウンタを使用したループは少ないですが、ループ回数をカウントするためだけの変数に対しては順番に  
`$i`, `$j`, `$k`  
を使用します。
## 定数

D言語では定数の定義方法がいくつかありますが、  
コンパイル時に値が確定するものは全て以下の方法で宣言します。

    enum HOGE_HOGE = 0;

## コメント

コメントは日本語で書きます。  

### クラス

クラス(インターフェース含む)の直前には必ずそれが何を表すのかを明記します。  
場合によっては同時に使用時の注意点なども記載することがあります。

    /+ [クラス/インターフェースの表す物] +/

### 関数/メソッド

関数又はメソッド宣言部の直前に以下のテンプレートを挿入します。  
これはprivateであろうがpublicであろうが変わりません。

    /+ [関数/メソッドの役割]
       引数1の名前 : 説明
       引数2の名前 : 説明
       ...
       返り値の説明
    +/

しかし、以下のような場合は一部または全てを省略して構いません。

* (関数/メソッド/引数の)名前が中学レベルの単語１語であり、処理が容易に想像できる場合。
* 役割に引数の説明が含まれた場合。

### その他の場合

その他の場合については、なるべくコメントを書かないようにします。  
しかし、直感的ではないトリッキーなコードを書いた際は一行程度の説明をつけてください。

## クラス

クラスの変数は全てprivate属性にします。  
アクセスする場合などは`@property`属性をつけたゲッター/セッターを使用します。  
これは、ゲッター/セッターを利用したデバッグをするためです。

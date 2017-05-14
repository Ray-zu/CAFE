/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.config.app;
import std.json;

/+ ビルド以降変化しない設定値 +/
enum STATIC_CONFIG_JSON = parseJSON( import( "app.json" ) );

/+ アプリケーションの基本情報 +/
class AppConfig
{
    public:
        enum Name = STATIC_CONFIG_JSON["name"].str;
};

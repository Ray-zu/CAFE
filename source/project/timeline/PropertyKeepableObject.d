/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;
import std.algorithm,
       std.array,
       std.format,
       std.regex;

debug = 1;

/+ プロパティを保持できるオブジェクトの共通部分   +
 + 引数にはプロパティの型と名前の宣言リストを渡す +/
template PropertyKeepableObject ( string defines )
{
    // プロパティ変数の定義
    public struct Properties { mixin( defines ); }
    private Properties properties;
}

/+ プロパティテーブルを生成するコード文字列を返す +/
private @property generatePropertyTable ( string defines )
{
}

/+ 型と名前の宣言リストから連想配列を生成
 + int hoge; => [ "hoge":"int" ] +/
private @property assocFromDefines ( string defines )
{
    enum EMPTY_REGEX   = `^\s*$`;
    enum STDTYPE_REGEX = `^\s*([^\s]+?)\s+(.+?)\s*$`;
    string[string] result;

    void push ( string vname, string vtype )
    {
        if ( !result.keys.canFind( vname ) )
            result[vname] = vtype;
    }

    auto def_lines = defines.split( ';' );
    foreach( string v; def_lines ) {
        if ( v.matchFirst( EMPTY_REGEX ) ) {}

        else if ( auto r = v.matchFirst( STDTYPE_REGEX ) ) {
            push( r[2], r[1] );
        } else throw new Exception( "Couldn't parse '%s'".format( v ) );
    }
    return result;
}
debug ( 1 ) unittest {
    assert( "int seisuu;string moziretsu;".assocFromDefines ==
            ["seisuu":"int", "moziretsu":"string"] );
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;

/+ プロパティを保持できるオブジェクトの共通部分   +
 + 引数にはプロパティの型と名前の宣言リストを渡す +/
template PropertyKeepableObject ( string defines )
{
    // プロパティ変数の定義
    public struct Properties { mixin( defines ); }
    private Properties properties;
}

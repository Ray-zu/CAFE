/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PropertyKeepableObject;
import cafe.project.timeline.property.PropertyList;

/+ プロパティリストを保持できるオブジェクトのインターフェース      +
 + クラスの多重継承ができないのでテンプレートで実態が定義されます。+/
interface PropertyKeepableObject
{
    public:
        @property PropertyList properties ();

        /+ プロパティを初期化 (各オブジェクトでオーバーライド) +/
        void initProperties ();
}



/+ Propertykeepableobjectの実体 +/
template PropertyKeepableObjectCommon ()
{
    private:
        PropertyList props;

    public:
        override @property PropertyList properties ()
        {
            return props;
        }
}

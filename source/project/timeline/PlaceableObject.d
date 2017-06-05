/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PlaceableObject;
import cafe.project.ObjectPlacingInfo;

/+ タイムラインに配置可能なオブジェクトのインターフェース          +
 + クラスの多重継承が出来ないのでテンプレートで実体が定義されます。+/
interface PlaceableObject
{
    public:
        @property ObjectPlacingInfo place ();
}



/+ Placeableobjectの実体 +/
template PlaceableObjectCommon
{
    private:
        ObjectPlacingInfo placing_info;

    public:
        override @property ObjectPlacingInfo place ()
        {
            return placing_info;
        }
}

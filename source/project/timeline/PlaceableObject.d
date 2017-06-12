/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PlaceableObject;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PropertyKeepableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.project.timeline.property.PropertyList;

/+ タイムラインに配置可能なオブジェクトの共通部分 +/
abstract class PlaceableObject : PropertyKeepableObject
{
    private:
        ObjectPlacingInfo opi   = null;
        PropertyList      props = new PropertyList;

    public:
        @property place () { return opi; }

        override @property PropertyList properties ()
        {
            return props;
        }
        override @property EffectList effectList ()
        {
            return new EffectList;  // 空のリスト
        }

        @property PlaceableObject copy ();

        this ( PlaceableObject src )
        {
            opi = new ObjectPlacingInfo( src.place );
            props = new PropertyList( src.properties );
        }

        this ( ObjectPlacingInfo p )
        {
            opi = p;
        }

        override void initProperties ()
        {
            // 継承したインターフェースの実体は抽象クラスでも書かなきゃいけないっぽい？
        }
}

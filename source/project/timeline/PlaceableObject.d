/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PlaceableObject;
import cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.project.timeline.PropertyKeepableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.project.timeline.property.PropertyList;
import std.json;

/+ タイムラインに配置可能なオブジェクトの共通部分 +/
abstract class PlaceableObject : PropertyKeepableObject
{
    private:
        ObjectPlacingInfo opi;
        PropertyList props;

    public:
        @property place () { return opi; }

        override @property PropertyList propertyList ()
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
            props = new PropertyList( src.propertyList );
        }

        this ( ObjectPlacingInfo p )
        {
            opi = p;
            props = new PropertyList;
            initProperties( p.frame.length );
        }

        override void initProperties ( FrameLength f )
        {
            // 継承したインターフェースの実体は抽象クラスでも書かなきゃいけないっぽい？
        }

        override @property JSONValue json ()
        {
            auto j = JSONValue( null );
            j["properties"] = JSONValue(propertyList.json);
            j["place"]      = JSONValue(place.json);
            j["effects"]    = JSONValue(effectList.json);
            return j;
        }

        /+ レンダリング情報にオブジェクトの内容を適用 +/
        void apply ( RenderingInfo );
}

/+ オブジェクト自体にエフェクトをかけられる場合の共通部分  +
 + コピーコンストラクタでEffectListのコピーを忘れるの注意！+/
template EffectKeepableObjectCommon ()
{
    import cafe.project.timeline.effect.EffectList;
    private:
        EffectList effs;

        /+ コピーコンストラクタで使う +/
        @property copyEffectFrom ( PlaceableObject src )
        {
            effs = new EffectList( src.effectList );
        }

    public:
        override @property EffectList effectList ()
        {
            return effs;
        }
}

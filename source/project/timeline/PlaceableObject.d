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
       cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.custom.NullObject;
import std.json;
import dlangui;

/+ タイムラインに配置可能なオブジェクトの共通部分 +/
abstract class PlaceableObject : PropertyKeepableObject
{
    private:
        ObjectPlacingInfo opi;
        PropertyList props;

    public:
        /+ オブジェクトの種類名 +/
        @property string type ();

        /+ オブジェクトの表示名 +/
        @property string name ();

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

        this ( JSONValue j, FrameLength f )
        {
            opi   = new ObjectPlacingInfo( j["place"], f );
            props = new PropertyList( j["properties"], f );
        }

        override void initProperties ( FrameLength f )
        {
            // 継承したインターフェースの実体は抽象クラスでも書かなきゃいけないっぽい？
            throw new Exception( "Not Implemented" );
        }

        override @property JSONValue json ()
        {
            auto j = JSONValue( null );
            j["properties"] = JSONValue(propertyList.json);
            j["place"]      = JSONValue(place.json);
            j["effects"]    = JSONValue(effectList.json);
            j["type"]       = JSONValue(type);
            return j;
        }

        /+ 指定された画像バッファにタイムラインのオブジェクト画像を描画 +/
        void draw ( DrawBuf b )
        {
            b.fill( 0x333388 );
        }

        /+ レンダリング情報にオブジェクトの内容を適用 +/
        void apply ( RenderingInfo );

        /+ type文字列からオブジェクト作成 +/
        static final PlaceableObject create ( JSONValue j, FrameLength f )
        {
            switch ( j["type"].str )
            {
                case "NullObject":
                    return new NullObject( j, f );

                default: throw new Exception( "Undefined Object" );
            }
        }
}

/+ オブジェクト自体にエフェクトをかけられる場合の共通部分  +
 + コピーコンストラクタでEffectListのコピーを忘れるの注意！+/
template EffectKeepableObjectCommon ()
{
    import cafe.project.timeline.effect.EffectList;
    import std.json;
    private:
        EffectList effs;

        /+ コピーコンストラクタで使う +/
        @property copyEffectFrom ( PlaceableObject src )
        {
            effs = new EffectList( src.effectList );
        }

        /+ JSONからEffectListを作成 +/
        @property createEffectJSON ( JSONValue j, FrameLength f )
        {
            effs = new EffectList( j, f );
        }

    public:
        override @property EffectList effectList ()
        {
            return effs;
        }
}

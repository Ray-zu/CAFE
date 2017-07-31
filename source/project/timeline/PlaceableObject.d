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
import std.algorithm,
       std.json;
import dlangui;

/+ タイムラインに配置可能なオブジェクトの共通部分 +/
abstract class PlaceableObject : PropertyKeepableObject
{
    private:
        ObjectPlacingInfo opi;
        PropertyList props;
        EffectList effs;

    public:
        @property string typeStr ();
        @property string name ();

        @property string styleId ()
        {
            return "TIMELINE_UNCATEGORIZED_OBJECT";
        }

        @property place () { return opi; }

        override @property PropertyList propertyList ()
        {
            return props;
        }
        @property EffectList effectList ()
        {
            return effs;
        }

        @property PlaceableObject copy ();

        this ( PlaceableObject src )
        {
            opi = new ObjectPlacingInfo( src.place );
            props = new PropertyList( src.propertyList, place.frame.length );
            effs = new EffectList( src.effectList, place.frame.length );
        }

        this ( ObjectPlacingInfo p )
        {
            opi = p;
            props = new PropertyList;
            effs = new EffectList;
            initProperties( p.frame.length );
        }

        this ( JSONValue j, FrameLength f )
        {
            opi   = new ObjectPlacingInfo( j["place"], f );
            props = new PropertyList( j["properties"], f );
            effs  = new EffectList( j["effects"], f );
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
            j["type"]       = JSONValue(typeStr);
            return j;
        }

        /+ 指定された画像バッファにタイムラインのオブジェクト画像を描画 +/
        void draw ( DrawBuf b, Rect r )
        {
            auto style = currentTheme.get( styleId );
            if ( style.backgroundDrawable )
                style.backgroundDrawable.drawTo( b, r );
        }

        /+ レンダリング情報にオブジェクトの内容を適用 +/
        void apply ( RenderingInfo );


        /+ オブジェクト登録処理 +/

        struct RegisteredObject
        {
            string name;
            PlaceableObject delegate ( JSONValue, FrameLength ) create;
        }
        static RegisteredObject[] registeredObjects;

        /+ オブジェクトを登録 +/
        template register ( T )
        {
            static this ()
            {
                RegisteredObject r;
                r.name = T.type;
                r.create = delegate ( JSONValue j, FrameLength f )
                {
                    return new T( j, f );
                };
                registeredObjects ~= r;
            }
        }

        /+ type文字列からオブジェクト作成 +/
        static final PlaceableObject create ( JSONValue j, FrameLength f )
        {
            auto n = j["type"].str;
            auto i = registeredObjects.countUntil!( x => x.name == n );
            if ( i == -1 ) throw new Exception( "Undefined Object." );
            return registeredObjects[i].create( j, f );
        }
}

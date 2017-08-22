/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PlaceableObject;
import cafe.json,
       cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.project.timeline.PropertyKeepableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.project.timeline.property.PropertyList,
       cafe.renderer.World;
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
            props = new PropertyList( j["properties"], place.frame.length );
            effs  = new EffectList( j["effects"], place.frame.length );
        }

        override void initProperties ( FrameLength f )
        {
            import cafe.project.timeline.effect.custom.Position,
                   cafe.project.timeline.effect.custom.Disable;
            effectList.clear;
            effectList += new Position( f );
            effectList += new Disable( f );
        }

        /+ 中間点を破壊しながらリサイズ +/
        void resizeDestroy ( uint len )
        {
            if ( len <= 0 )
                throw new Exception( "Cannot Resize Length to Under 1" );

            void proc ( PropertyList ps )
            {
                ps.properties.values.each!( x => x.resizeDestroy(len) );
            }
            proc( propertyList );
            effectList.effects.each!( x => proc( x.propertyList ) );
        }

        /+ 左端をリサイズ +/
        void resizeStart ( FrameAt f )
        {
            f.value = min( f.value, place.frame.parentLength.value );

            auto ed = place.frame.end.value;
            f.value = f.value >= ed ? ed - 1 : f.value;
        
            auto new_len = ed - f.value;
            resizeDestroy( new_len );
            place.frame.resizeStart( f );
        }

        /+ 右端をリサイズ +/
        void resizeEnd ( FrameAt f )
        {
            f.value = min( f.value, place.frame.parentLength.value );

            auto st = place.frame.start.value;
            f.value = f.value <= st ? st + 1 : f.value;

            auto new_len = f.value - st;
            resizeDestroy( new_len );
            place.frame.resizeEnd( f );
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

            import cafe.gui.utils.Font;
            auto x = r.left + style.padding.left;
            auto y = r.top + (r.bottom-r.top)/2;
            style.font.drawLeftCenteredText( b, x,y, name, style.textColor );
        }

        /+ レンダリング情報にオブジェクトの内容を適用 +/
        void apply ( RenderingInfo r )
        {
            auto f = new FrameAt( r.frame.value - place.frame.start.value );
            auto w = createWorld( r, f );
            effectList.apply( w, f );
            r.effectStage += w;
        }
        World createWorld ( RenderingInfo, FrameAt );


        /+ オブジェクト登録処理 +/

        struct RegisteredObject
        {
            string name;
            string icon;
            PlaceableObject delegate ( JSONValue, FrameLength ) create;
            PlaceableObject delegate ( ObjectPlacingInfo )      createAt;
        }
        static RegisteredObject[] registeredObjects;

        /+ オブジェクトを登録 +/
        template register ( T )
        {
            static this ()
            {
                RegisteredObject r;
                r.name = T.type;
                r.icon = T.icon;
                r.create = delegate ( JSONValue j, FrameLength f )
                {
                    return new T( j, f );
                };
                r.createAt = delegate ( ObjectPlacingInfo opi )
                {
                    return new T( opi );
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

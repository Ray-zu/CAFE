/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.NullObject;
import cafe.project.RenderingInfo,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.renderer.World,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.graphics.Color,
       cafe.renderer.polygon.Ngon,
       cafe.renderer.polygon.PolygonData;
import gl3n.linalg;
import std.conv,
       std.json;

debug = 0;

/+ デバッグ用の何もしないオブジェクト +/
class NullObject : PlaceableObject
{
    mixin register!NullObject;
    public:
        static @property type ()
        {
            return "NullObject";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string typeStr () { return type; }
        // static の override ができない！

        override @property string name ()
        {
            return "NullObject";
        }

        override @property PlaceableObject copy ()
        {
            return new NullObject( this );
        }

        this ( NullObject src )
        {
            super( src );
        }

        this ( ObjectPlacingInfo f )
        {
            super( f );

            // TODO test
            import cafe.project.timeline.effect.custom.Position;
            effectList += new Position( f.frame.length );
        }

        this ( JSONValue j, FrameLength f )
        {
            super( j, f );
        }

        override void initProperties ( FrameLength f )
        {
            import cafe.project.timeline.property.Property;
            propertyList["hoge"] = new PropertyBase!string( f, "hogera" );
        }

        override void apply ( RenderingInfo rinfo )
        {
            BMP color_bmp = new BMP(2, 2,[
                    RGBA(0.0, 1.0, 0.0, 1.0),
                    RGBA(1.0, 0.0, 0.0, 1.0),
                    RGBA(0.0, 1.0, 1.0, 1.0),
                    RGBA(1.0, 0.0, 1.0, 1.0)
                ]);

            /+ 実際のポリゴン生成プロセス +/
            World w = new World;
            w += new Ngon( 5, 640, Transform(
                    vec3( 200.0, 150.0, -120.0 ),
                    vec3( 0.0, 0.0, -35.0 ),
                    vec3( 0.5, 0.3, 1.0 )
                ), color_bmp );
        }

        debug (1) unittest {
            auto hoge = new NullObject(
                    new ObjectPlacingInfo( new LayerId(0),
                        new FramePeriod( new FrameLength(5), new FrameAt(0), new FrameLength(1) ) ) );

            auto hoge2 = PlaceableObject.create( hoge.json, hoge.place.frame.length );
            assert( hoge.json.to!string == hoge2.json.to!string );
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.RectangleObject;
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

/+ デバッグ用の何もしないオブジェクト +/
class RectangleObject : PlaceableObject
{
    mixin register!RectangleObject;

    enum MaxSize = 10000;

    public:
        static @property type ()
        {
            return "Rectangle";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string typeStr () { return type; }
        // static の override ができない！

        override @property string name ()
        {
            return type;
        }

        override @property PlaceableObject copy ()
        {
            return new RectangleObject( this );
        }

        this ( RectangleObject src )
        {
            super( src );
        }

        this ( ObjectPlacingInfo f )
        {
            super( f );
        }

        this ( JSONValue j, FrameLength f )
        {
            super( j, f );
        }

        override void initProperties ( FrameLength f )
        {
            import cafe.project.timeline.property.LimitedProperty;
            propertyList["Size"] = new LimitedProperty!float( f, 200, MaxSize, 0 );
        }

        override void apply ( RenderingInfo rinfo )
        {
            auto f = new FrameAt( rinfo.frame.value - place.frame.start.value );

            BMP color = new BMP( 1, 1 );
            color[0,0] = RGBA( 1.0, 1.0, 1.0, 1.0 );

            /+ 実際のポリゴン生成プロセス +/
            World w = new World;

            auto sz = castedProperty!float("Size").get(f) / 2;
            auto pos = [
                vec3(-sz, sz,0),
                vec3( sz, sz,0),
                vec3( sz,-sz,0),
                vec3(-sz,-sz,0)
            ];
            auto trans = Transform(
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 1.0, 1.0, 1.0 )
            );
            w += new Quadrangle( pos, trans, color );

            effectList.apply( w, f );
            rinfo.effectStage += w;
        }
}

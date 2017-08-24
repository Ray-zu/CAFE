/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.Circle;
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

/+ 円形オブジェクト +/
class Circle : PlaceableObject
{
    enum MaxRange = 10000;
    enum MaxPoly  = 10000;

    mixin register!Circle;

    public:
        static @property type ()
        {
            return "Circle";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string typeStr () { return type; }

        override @property string name ()
        {
            return type;
        }

        override @property PlaceableObject copy ()
        {
            return new Circle( this );
        }

        this ( Circle src )
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
            super.initProperties( f );

            import cafe.project.timeline.property.LimitedProperty;
            propertyList["Range"   ] = new LimitedProperty!float( f, 200, MaxRange, 0 );
            propertyList["Accuracy"] = new LimitedProperty!int  ( f, 100, MaxPoly , 1 );
        }

        override World createWorld ( RenderingInfo r, FrameAt f )
        {
            BMP color = new BMP( 1, 1 );
            color[0,0] = RGBA( 1.0, 1.0, 1.0, 1.0 );

            World w = new World;

            auto s = castedProperty!float("Range").get(f);
            auto p = castedProperty!int("Accuracy").get(f);
            auto trans = Transform(
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 1.0, 1.0, 1.0 )
            );

            w += new Ngon( p, s, trans, color );

            return w;
        }
}

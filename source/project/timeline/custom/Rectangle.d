/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.Rectangle;
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

/+ 四角形オブジェクト +/
class Rectangle : PlaceableObject
{
    mixin register!Rectangle;

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
            return new Rectangle( this );
        }

        this ( Rectangle src )
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
            propertyList["Width" ] = new LimitedProperty!float( f, 200, MaxSize, 0 );
            propertyList["Height"] = new LimitedProperty!float( f, 200, MaxSize, 0 );
        }

        override World createWorld ( RenderingInfo r, FrameAt f )
        {
            BMP color = new BMP( 1, 1 );
            color[0,0] = RGBA( 1.0, 1.0, 1.0, 1.0 );

            World w = new World;

            auto wi = castedProperty!float("Width" ).get(f);
            auto he = castedProperty!float("Height").get(f);
            auto size = vec2( wi, he );
            auto trans = Transform(
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 0.0, 0.0, 0.0 ),
                vec3( 1.0, 1.0, 1.0 )
            );

            w += new cafe.renderer.polygon.Ngon.Rectangle( size, trans, color );

            return w;
        }
}

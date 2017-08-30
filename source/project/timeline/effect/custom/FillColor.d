/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.FillColor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.property.LimitedProperty,
       cafe.renderer.World,
       cafe.renderer.graphics.Bitmap,
       cafe.renderer.graphics.Color;
import std.algorithm,
       std.json;

/+ ポリゴンの色をすべて塗りつぶすエフェクト +/
class FillColor : Effect
{
    enum MaxColor = 10.0;

    mixin register!FillColor;

    public:
        static @property type ()
        {
            return "FillColor";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string name () { return type; }

        override @property Effect copy ( FrameLength f )
        {
            return new FillColor( this, f );
        }

        this ( FillColor src, FrameLength f )
        {
            super( src, f );
        }

        this ( FrameLength f )
        {
            super( f );
        }

        this ( JSONValue j, FrameLength f )
        {
            super( j, f );
        }

        override void initProperties ( FrameLength f )
        {
            propertyList["R"] = new LimitedProperty!float( f, 1.0, MaxColor, -MaxColor );
            propertyList["G"] = new LimitedProperty!float( f, 1.0, MaxColor, -MaxColor );
            propertyList["B"] = new LimitedProperty!float( f, 1.0, MaxColor, -MaxColor );
            propertyList["A"] = new LimitedProperty!float( f, 1.0, MaxColor, -MaxColor );
        }

        override void apply ( World w, FrameAt f )
        {
            auto r = castedProperty!float( "R" ).get(f);
            auto g = castedProperty!float( "G" ).get(f);
            auto b = castedProperty!float( "B" ).get(f);
            auto a = castedProperty!float( "A" ).get(f);
            auto col = RGBA( r, g, b, a );

            void fill ( BMP b )
            {
                auto len = b.width * b.height;
                auto bmp = b.bitmap.ptr;
                for ( auto i = 0; i < len; i++ )
                    bmp[i] = col;
            }
            w.polygons.each!( x => fill( x.texture ) );
        }
}

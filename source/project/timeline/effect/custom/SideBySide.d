/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.SideBySide;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.property.LimitedProperty,
       cafe.renderer.World,
       cafe.renderer.polygon.Polygon;
import std.json;

/+ ポリゴン集合を並べて配置 +/
class SideBySide : Effect
{
    enum MaxPosition = 10000;
    enum MaxCount    = 10000;

    mixin register!SideBySide;

    public:
        static @property type ()
        {
            return "SideBySide";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string name () { return type; }
        // static の override ができないので

        override @property Effect copy ( FrameLength f )
        {
            return new SideBySide( this, f );
        }

        this ( SideBySide src, FrameLength f )
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
            propertyList["Xspace"] = new LimitedProperty!float( f, 100, MaxPosition, -MaxPosition );
            propertyList["Yspace"] = new LimitedProperty!float( f, 100, MaxPosition, -MaxPosition );
            propertyList["Zspace"] = new LimitedProperty!float( f,   0, MaxPosition, -MaxPosition );
            propertyList["Xcount"] = new LimitedProperty!int( f, 10, MaxCount, 1 );
            propertyList["Ycount"] = new LimitedProperty!int( f, 10, MaxCount, 1 );
            propertyList["Zcount"] = new LimitedProperty!int( f,  1, MaxCount, 1 );
        }

        override void apply ( World w, FrameAt f )
        {
            auto xs = castedProperty!float( "Xspace" ).get( f );
            auto ys = castedProperty!float( "Yspace" ).get( f );
            auto zs = castedProperty!float( "Zspace" ).get( f );
            auto xc = castedProperty!int( "Xcount" ).get( f );
            auto yc = castedProperty!int( "Ycount" ).get( f );
            auto zc = castedProperty!int( "Zcount" ).get( f );

            auto temp_polys = w.polygons;
            void copyPolyAt ( float x, float y, float z )
            {
                foreach ( poly; temp_polys ) {
                    auto p = new Polygon( poly );
                    auto trans = p.transform;
                    trans.Translate.vector[0] += x;
                    trans.Translate.vector[1] += y;
                    trans.Translate.vector[2] += z;
                    p.transform = trans;
                    w += p;
                }
            }

            for ( auto x = 0; x < xc; x++ )
            {
                auto xpos = (x - xc/2) * xs;
                for ( auto y = 0; y < yc; y++ )
                {
                    auto ypos = (y - yc/2) * ys;
                    for ( auto z = 0; z < zc; z++ )
                    {
                        auto zpos = (z - zc/2) * zs;
                        if ( xpos != 0 || ypos != 0 || zpos != 0 )
                            copyPolyAt( xpos, ypos, zpos );
                    }
                }
            }
        }
}

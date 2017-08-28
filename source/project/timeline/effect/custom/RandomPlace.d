/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.RandomPlace;
import cafe.random,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.property.LimitedProperty,
       cafe.renderer.World,
       cafe.renderer.polygon.Polygon;
import std.conv,
       std.json;

/+ ポリゴン集合を並べて配置 +/
class RandomPlace : Effect
{
    enum MaxPosition = 10000;
    enum MaxCount    = 10000;
    enum MaxSeed     = 10000;

    mixin register!RandomPlace;

    public:
        static @property type ()
        {
            return "RandomPlace";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string name () { return type; }
        // static の override ができないので

        override @property Effect copy ( FrameLength f )
        {
            return new RandomPlace( this, f );
        }

        this ( RandomPlace src, FrameLength f )
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
            propertyList["Count"] = new LimitedProperty!int( f, 10, MaxCount, 1 );
            propertyList["Seed" ] = new LimitedProperty!int( f, 10, MaxSeed, 0 );

            propertyList["Xrange"] = new LimitedProperty!float( f, 100, MaxPosition, 0 );
            propertyList["Yrange"] = new LimitedProperty!float( f, 100, MaxPosition, 0 );
            propertyList["Zrange"] = new LimitedProperty!float( f, 100, MaxPosition, 0 );
        }

        override void apply ( World w, FrameAt f )
        {
            auto cnt = castedProperty!int("Count").get(f);
            auto rnd = new Random!int( castedProperty!int("Seed").get(f) );

            auto xr = (castedProperty!float( "Xrange" ).get( f ) * 100).to!int;
            auto yr = (castedProperty!float( "Yrange" ).get( f ) * 100).to!int;
            auto zr = (castedProperty!float( "Zrange" ).get( f ) * 100).to!int;

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

            for ( auto i = 0; i < cnt; i++ ) {
                auto x = rnd.generate( -xr, xr ) / 100.0;
                auto y = rnd.generate( -yr, yr ) / 100.0;
                auto z = rnd.generate( -zr, zr ) / 100.0;
                copyPolyAt( x, y, z );
            }
        }
}

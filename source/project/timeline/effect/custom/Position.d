/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.Position;
import cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.property.LimitedProperty,
       cafe.renderer.World;
import std.json;

/+ ポリゴンの位置をずらすエフェクト +/
class Position : Effect
{
    enum MaxPosition = 10000;

    mixin register!Position;

    public:
        static @property type ()
        {
            return "Position";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string name () { return type; }
        // static の override ができないので

        override @property Effect copy ( FrameLength f )
        {
            return new Position( this, f );
        }

        this ( Position src, FrameLength f )
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
            propertyList["X"] = new LimitedProperty!float( f, 0, MaxPosition, -MaxPosition );
            propertyList["Y"] = new LimitedProperty!float( f, 0, MaxPosition, -MaxPosition );
            propertyList["Z"] = new LimitedProperty!float( f, 0, MaxPosition, -MaxPosition );
        }

        override void apply ( RenderingInfo r, FrameAt f )
        {
            auto w = r.effectStage;

            auto x = castedProperty!float( "X" ).get( f );
            auto y = castedProperty!float( "Y" ).get( f );
            auto z = castedProperty!float( "Z" ).get( f );

            foreach ( poly; w.polygons ) {
                foreach ( ref vec; poly.position ) {
                    vec.vector[0] += x;
                    vec.vector[1] += y;
                    vec.vector[2] += z;
                }
            }
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.Disable;
import cafe.project.ObjectPlacingInfo,
       cafe.project.RenderingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.property.BoolProperty,
       cafe.renderer.World;
import std.json;

/+ ポリゴンを全て削除するエフェクト +/
class Disable : Effect
{
    mixin register!Disable;

    public:
        static @property type ()
        {
            return "Disable";
        }
        static @property icon ()
        {
            return "obj_ctg_others";
        }
        override @property string name () { return type; }
        // static の override ができないので

        override @property Effect copy ( FrameLength f )
        {
            return new Disable( this, f );
        }

        this ( Disable src, FrameLength f )
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
            propertyList["disable"] = new BoolProperty( f, false );
        }

        override void apply ( World w, FrameAt f )
        {
            // TODO
        }
}

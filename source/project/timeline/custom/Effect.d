/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.custom.Effect;
import cafe.project.RenderingInfo,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.effect.EffectList,
       cafe.renderer.World;
import gl3n.linalg;
import std.conv,
       std.json;

/+ エフェクトオブジェクト +/
class Effect : PlaceableObject
{
    mixin register!Effect;

    public:
        static @property type ()
        {
            return "Effect";
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
            return new Effect( this );
        }

        this ( Effect src )
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
            //super.initProperties( f );
        }

        override void apply ( RenderingInfo r )
        {
            auto f = new FrameAt( r.frame.value - place.frame.start.value );
            effectList.apply( r.effectStage, f );
        }

        override World createWorld ( RenderingInfo, FrameAt )
        {
            throw new Exception( "Not Implemented" );
        }
}

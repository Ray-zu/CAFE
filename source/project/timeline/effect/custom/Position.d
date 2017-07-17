/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.effect.custom.Position;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.effect.Effect,
       cafe.renderer.World;
import std.json;

/+ ポリゴンの位置をずらすエフェクト +/
class Position : Effect
{
    mixin register!Position;

    public:
        static @property type ()
        {
            return "Position";
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
            // TODO プロパティ追加
        }

        override World apply ( World w )
        {
            // TODO ポリゴンの位置を一つ一つずらす
            return w;
        }
}

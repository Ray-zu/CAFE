/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.Timeline;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject;
import std.algorithm,
       std.array;

debug = 0;

/+ タイムラインデータ +/
class Timeline
{
    private:
        PlaceableObject[] objs;
        FrameLength frame_len;

    public:
        @property objects () { return objs;      }
        @property length  () { return frame_len; }

        this ()
        {
            objs = [];
            frame_len = new FrameLength(1);
        }

        /+ フレームfの処理対象のオブジェクトの配列を返す +/
        @property objectsAtFrame ( FrameAt f )
        {
            return objects.filter!( x => x.place.frame.isInRange(f) ).array;
        }

        debug (1) unittest {
            auto hoge = new Timeline;
            assert( hoge.objectsAtFrame( new FrameAt(0) ).length == 0 );
        }
}

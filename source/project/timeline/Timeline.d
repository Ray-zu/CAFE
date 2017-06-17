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

        this ( Timeline src )
        {
            src.objects.each!( x => objs ~= x.copy );
            frame_len = new FrameLength( src.length );
        }

        this ( FrameLength f = new FrameLength(1) )
        {
            objs = [];
            frame_len = f;
        }

        /+ オブジェクトを追加 +/
        void addObject ( PlaceableObject o )
        {
            objs ~= o;
        }

        /+ フレームfの処理対象のオブジェクトの配列を返す +/
        @property objectsAtFrame ( FrameAt f )
        {
            return objects.filter!( x => x.place.frame.isInRange(f) ).array;
        }

        debug (1) unittest {
            import cafe.project.timeline.custom.NullObject;
            auto hoge = new Timeline( new FrameLength( 10 ) );

            auto opi = new ObjectPlacingInfo( new LayerId(0),
                   new FramePeriod( hoge.length, new FrameAt(0), new FrameLength(5) ) );
            auto obj1 = new NullObject( opi );
            hoge.addObject( obj1 );

            assert( hoge.objectsAtFrame( new FrameAt(0) ).length == 1 );
        }
}

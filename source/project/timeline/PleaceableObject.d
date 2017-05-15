/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PleaceableObject;
import std.conv;

/+ タイムラインに配置できるオブジェクト                +
 + 主にオブジェクトの開始/終了フレームやレイヤ数を管理 +/
template PleaceableObject ()
{
    private:
        /+ タイムライン上の位置情報 +/
        uint start_frame  = 0;
        uint frame_length = 1;
        uint layer_id     = 0;

    public:
        /+ プロパティ取得 +/
        @property startFrame  ()         { return start_frame;              }
        @property frameLength ()         { return frame_length;             }
        @property layerId     ()         { return layer_id;                 }
        @property endFrame    ()         { return startFrame + frameLength; }

        /+ オブジェクトの長さを固定したままstartFrameを変更します。 +/
        bool move ( uint start_frame )
        {
            this.start_frame = start_frame;
            return true;
        }

        /+ オブジェクトの右端を固定したままstartFrameを変更します。 +/
        bool resizeStart ( uint start_frame )
        {
            auto old_st_frame  = this.start_frame;
            auto new_st_frame  = start_frame;
            auto diff_st_frame = old_st_frame.to!int - new_st_frame.to!int;

            if ( frameLength.to!int + diff_st_frame > 0 ) {
                frame_length += diff_st_frame;
                this.start_frame = new_start_frame;
                return true;
            }

            return false;
        }

        /+ オブジェクトの左端を固定したまま右端が指定されたフレーム数になるよう変更します。 +/
        bool resizeEnd ( uint end_frame )
        {
            auto new_length = end_frame - start_frame;

            if ( new_length > 0 ) {
                frame_length = new_length;
                return true;
            }

            return false;
        }
}

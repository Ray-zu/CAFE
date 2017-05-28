/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.PlaceableObject;
import cafe.project.ObjectPlacingInfo;
import std.conv;

/+ プロパティを保持できるオブジェクトの共通部分 +/
template PropertyKeepableObject ()
{
}

/+ タイムラインに配置できるオブジェクト                +
 + 主にオブジェクトの開始/終了フレームやレイヤ数を管理 +/
abstract class PlaceableObject
{
    mixin PropertyKeepableObject;

    private:
        FramePeriod frame_period;
        uint layer_id = 0;

    public:
        /+ プロパティ取得 +/
        @property frame    () { return frame_period; }
        @property layerId  () { return layer_id;     }
}

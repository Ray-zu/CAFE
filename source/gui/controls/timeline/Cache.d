/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Cache;
import cafe.project.Project,
       cafe.project.timeline.Timeline;
import dlangui;

/+ タイムライン描画時のデータ受け渡しクラス +/
class Cache
{
    enum MinimumGridInterval = 5;
    private:
        Project  pro;
        Timeline tl;

        float px_per_frame;
        uint  frame_per_grid;

    public:
        @property project  () { return pro; }
        @property timeline () { return tl; }

        @property pxPerFrame   () { return px_per_frame; }
        @property framePerGrid () { return frame_per_grid; }

        this ( Project p, Timeline t )
        {
            pro = p;
            tl  = t;
        }

        /+ グリッド関連のキャッシュを更新 +/
        void updateGridCache ( Rect r )
        {
            if ( !timeline || r.width <= 0 ) return;

            auto left  = timeline.leftFrame;
            auto right = timeline.rightFrame;
            if ( left >= right ) {
                timeline.rightFrame = left + 1;
                updateGridCache( r );
            }
            auto width = r.width.to!float;
            auto len   = right - left;

            px_per_frame = width / len;
            frame_per_grid = delegate ()
            {
                auto r = 1;
                while ( width / (len/r) < MinimumGridInterval )
                    r++;
                return r;
            }();
        }
}

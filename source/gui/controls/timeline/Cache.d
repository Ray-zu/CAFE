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

        float grid_interval  = 1;
        float frame_per_grid = 1;

    public:
        @property project  () { return pro; }
        @property timeline () { return tl; }

        @property gridInterval () { return grid_interval; }
        @property framePerGrid () { return frame_per_grid; }

        this ( Project p, Timeline t )
        {
            pro = p;
            tl  = t;
        }

        /+ グリッド関連のキャッシュを更新 +/
        void updateGridCache ( Rect r )
        {
            auto left  = timeline.leftFrame;
            auto right = timeline.rightFrame;

            if ( left >= right ) {
                timeline.rightFrame = left + 1;
                updateGridCache( r );
            }

            auto width    = r.width.to!float;
            auto grid_len = right - left;
            while ( width/grid_len < MinimumGridInterval )
                grid_len--;

            grid_interval = width / grid_len;
            frame_per_grid = (right - left) / grid_interval;
        }
}

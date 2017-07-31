/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Cache;
import cafe.project.Project,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.gui.controls.timeline.Line;
import std.algorithm,
       std.conv;
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

        Line[] lines_cache;

    public:
        @property project  () { return pro; }
        @property timeline () { return tl; }

        @property pxPerFrame   () { return px_per_frame; }
        @property framePerGrid () { return frame_per_grid; }

        uint headerWidth = 150;
        @property lines () { return lines_cache; }

        this ( Project p, Timeline t )
        {
            pro = p;
            tl  = t;
            lines_cache = [];
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

        /+ ライン情報更新 +/
        void updateLinesCache ()
        {
            lines_cache = [];
            if ( !timeline ) return;

            void addPropertyLine ()
            {
                auto o = timeline.selecting;
                foreach ( k,v; o.propertyList.properties )
                    lines_cache ~= new PropertyLine( this, k, v );
            }
            auto select_layer = timeline.selecting.place.layer.value;
            foreach ( i; 0 .. timeline.layerLength + 10 ) {
                auto o = timeline[ new LayerId(i) ];
                lines_cache ~= new LayerLine( this, i, o );
                if ( select_layer == i ) addPropertyLine;
            }
        }

        /+ グリッド相対座標Xからフレーム数へ +/
        uint xToFrame ( int x )
        {
            auto len  = timeline.length.value;
            auto left = timeline.leftFrame.to!int;
            auto vf   = (x/pxPerFrame).to!int;
            return max( 0, min( vf + left, len ) ).to!uint;
        }
}

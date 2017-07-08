/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.PropertyGraph;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.Property,
       cafe.project.timeline.property.MiddlePoint;
import dlangui;

/+ プロパティラインに表示するグラフを描画＆処理する +/
class PropertyGraph
{
    private:
        Property prop;
        uint st_frame;
        uint frame_length;
        Rect draw_area;

    public:
        @property property    () { return prop; }
        @property startFrame  () { return st_frame; }
        @property frameLength () { return frame_length; }

        @property drawArea () { return draw_area; }
        @property drawArea ( Rect r )
        {
            draw_area = r;
        }

        @property visible () { return prop !is null; }

        this ()
        {
            prop = null;
            st_frame = 0;
            frame_length = 1;
            draw_area = Rect( 0,0,0,0 );
        }

        /+ プロパティを更新 +/
        void setProperty ( Property p, int st = 0, int len = 0 )
        {
            prop = p;
            st_frame = st.to!uint;
            frame_length = len.to!uint;
        }

        void draw ( DrawBuf b )
        {
            b.fillRect( drawArea, 0xfffffff );
        }
}

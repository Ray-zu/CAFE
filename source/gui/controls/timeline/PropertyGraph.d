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
    enum MPRectSize = 7;
    enum GraphColor = 0x888888;

    private:
        Property prop;
        uint st_frame;
        uint frame_length;
        Rect draw_area;

        /+ グラフ位置相対Y座標から値へ +/
        @property yToValue ( int y )
        {
            auto ratio = y/drawArea.height.to!float;
            auto topv  = ratio*(prop.maxFloat - prop.minFloat);
            return prop.maxFloat - topv;
        }

        /+ 値からグラフ位置相対Y座標へ +/
        @property valueToY ( float v )
        {
            v -= prop.minFloat;
            auto ratio = v/(prop.maxFloat - prop.minFloat);
            auto y = drawArea.height - ratio*drawArea.height;
            return y;
        }

        /+ グラフ位置相対座標Xからフレーム数へ +/
        @property xToFrame ( int x )
        {
            auto unit = drawArea.width / frameLength.to!float;
            return startFrame + (x/unit).to!int;
        }

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
            if ( p is null || p.increasable ) {
                prop = p;
                st_frame = st.to!uint;
                frame_length = len.to!uint;
            }
        }

        /+ グラフ描画 +/
        void draw ( DrawBuf b )
        {
            int last_frame = -1;
            Point last_point;

            foreach ( x; 0 .. (drawArea.width+1) ) {
                auto f = xToFrame( x );

                if ( last_frame == f || property.frame.value <= f )
                    continue;

                auto v = property.getFloat( new FrameAt(f) );
                auto point = Point( x, valueToY(v).to!int );

                if ( last_frame >= 0 ) {
                    auto l = drawArea.left;
                    auto t = drawArea.top;
                    auto p1 = Point( last_point.x+l, last_point.y+t );
                    auto p2 = Point( point.x     +l, point.y     +t );
                    b.drawLine( p1, p2, GraphColor );
                }
                last_frame = f;
                last_point = point;
            }
        }

        /+ 左クリックされた時に呼ばれる(グラフ相対座標) +/
        bool onLeftDown ( int x, int y, ushort keys )
        {
            auto f = xToFrame(x);
            auto v = yToValue(y);
            Log.d( f.to!string );
            prop.setFloat( new FrameAt(f), v );
            return true;
        }
}

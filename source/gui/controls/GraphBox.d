/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.GraphBox;
import std.algorithm,
       std.conv,
       std.format,
       std.math,
       std.traits;
import dlangui;

/+ グラフ +/
class GraphBox (T, string XLabel="x", string YLabel="y") : Widget
    if ( isNumeric!T )
{
    private:
        bool  value_visible = false;
        Point value_point   = { x:0, y:0 };
        T[]   graph_data    = [];

        /+ グラフのxから画面座標を返す +/
        auto posFromX ( uint x )
        {
            x -= minX; auto y = graph[x]-minY;
            auto px_x = width.to!float/(maxX-minX).to!float;
            auto px_y = height.to!float/(maxY-minY).to!float;
            return Point( (px_x*x).to!int, (px_y*y).to!int );
        }

        /+ 画面座標からグラフのxを返す +/
        auto xFromPos ( Point p )
        {
            return round( p.x / (width.to!float/(maxX-minX).to!float) ).to!uint;
        }

        /+ カーソルの位置にホバー中の値を描画 +/
        void drawValue ( DrawBuf b )
        {
            enum RectSize = 5;

            auto p = value_point;
            auto x = xFromPos(p), y = graph[x];
            auto v = "%s=%s, %s=%s".format( XLabel,
                    x.to!string, YLabel, y.to!string );
            font.drawText( b, p.x, p.y, v.to!dstring, textColor );

            p = posFromX( x );
            b.drawLine( Point(p.x,0), Point(p.x,height), 0 );
        }

    public:
        @property graph () { return graph_data; }

        this ( string id, T[] g = [] )
        {
            g.length = 500;
            foreach ( i; 0 .. 500 )  // テストコード
                g[i] = i;

            super( id );
            backgroundColor = 0x222222;
            textColor = 0x999999;
            mouseEvent = delegate ( Widget w, MouseEvent e )
            {
                value_visible = e.action != MouseAction.Leave;
                value_point   = e.pos;
                w.invalidate;
                // TODO : グラフがクリックされた時に独自のハンドラを呼ぶ
                return true;
            };

            graph_data = g;
        }

        // 縦軸横軸の最大値/最小値を取得
        @property maxY () { return graph_data.reduce!max; }
        @property minY () { return graph_data.reduce!min; }
        @property maxX () { return graph_data.length-1;   }
        @property minX () { return 0;                     }

        override void onDraw ( DrawBuf b )
        {
            super.onDraw(b);
            if ( graph.length == 0 ) return;

            foreach ( i,v; graph[0 .. $-1] )
                b.drawLine( posFromX(i), posFromX(i+1), textColor );

            if ( value_visible ) drawValue(b);
        }
}

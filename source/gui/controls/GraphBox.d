/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.GraphBox;
import std.algorithm,
       std.conv,
       std.traits;
import dlangui;

/+ グラフ +/
class GraphBox (T) : Widget
    if ( isNumeric!T )
{
    private:
        T[] graph_data;     // グラフデータ

    public:
        @property graph () { return graph_data; }

        this ( string id, T[] g = [] )
        {
            g = [0, 100, 50];   // テストコード

            super( id );
            backgroundColor = 0x333333;
            textColor = 0x999999;
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

            auto maxY = this.maxY, minY = this.minY;
            auto maxX = this.maxX, minX = this.minX;

            auto posFromX ( uint x )
            {
                x -= minX; auto y = graph[x]-minY;
                auto px_x = b.width.to!float/(maxX-minX).to!float;
                auto px_y = b.height.to!float/(maxY-minY).to!float;
                return Point( (px_x*x).to!int, (px_y*y).to!int );
            }

            foreach ( i,v; graph[0 .. $-1] )
                b.drawLine( posFromX(i), posFromX(i+1), textColor );
        }
}

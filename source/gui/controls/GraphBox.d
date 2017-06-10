/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.GraphBox;
import std.algorithm,
       std.traits;
import dlangui;

/+ グラフコンポーネント +/
class GraphBox (T) : Widget
    if ( isNumeric!T )
{
    private:
        T[] graph_data;     // グラフデータ

    public:
        @property graph () { return graph_data; }

        this ( string id, T[] g = [] )
        {
            super( id );
            graph_data = g;
        }

        // 縦軸横軸の最大値/最小値を取得
        @property maxY () { return graph_data.reduce!max; }
        @property minY () { return graph_data.reduce!min; }
        @property maxX () { return graph_data.length-1;   }
        @property minX () { return 0;                     }
}

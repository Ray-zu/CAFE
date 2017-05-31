/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Property;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.property.MiddlePoint;

debug = 1;

/+ プロパティデータのインターフェース +/
interface Property
{
    public:
        @property FrameLength   frame        ();
        @property MiddlePoint[] middlePoints ();

        /+ ユーザーの入力した文字列をプロパティに変換 +/
        void   set ( FrameAt, string );
        string get ( FrameAt );
}

/+ プロパティデータ +/
class PropertyBase (T) : Property
{
    private:
        alias MPoint = MiddlePointBase!T;

        FrameLength frame_len;
        MiddlePoint[]    middle_points;
        T           end_value;

    public:
        override @property FrameLength   frame        () { return frame_len;     }
        override @property MiddlePoint[] middlePoints () { return middle_points; }
                 @property T             endValue     () { return end_value;     }

        this ( FrameLength f, T v )
        {
            frame_len = f;
            middle_points = [new MPoint( v,
                    new FramePeriod( f, new FrameAt(0), new FrameAt(f.value-1) ) )];
            end_value = v;
        }

        override void set ( FrameAt f, string v )
        {
            throw new Exception( "Not Implemented" );
        }

        override string get ( FrameAt f )
        {
            throw new Exception( "Not Implemented" );
        }

        debug ( 1 ) unittest {
            auto hoge = new PropertyBase!float( new FrameLength(50), 20 );
            assert( hoge.middlePoints.length == 1 );
        }
}

/+ プロパティのプリセット +/
enum PropertyPreset
{
    Positioning2D
}

/+ プリセットに応じたプロパティ文字列連想配列を返す +/
@property loadPropertyPreset ( PropertyPreset p, FrameLength f )
{
    Property[string] result;
    switch ( p )
    {
        case PropertyPreset.Positioning2D:
            result["X"] = new PropertyBase!float( f, 0 );
            result["Y"] = new PropertyBase!float( f, 0 );
            break;

        default: throw new Exception( "It was unexpected.." );
    }
    return result;
}

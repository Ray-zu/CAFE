/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Easing;
import cafe.project.ObjectPlacingInfo;

/+ イージング関数のベースクラス +/
abstract class EasingFunction
{
    private:
        float       st_value;
        float       ed_value;
        FrameLength dur;

    public:
        @property start    () { return st_value; }
        @property end      () { return ed_value; }
        @property duration () { return dur;      }

        @property start ( float s ) { st_value = s; }
        @property end   ( float e ) { ed_value = e; }

        this ( float s, float e, FrameLength d )
        {
            start = s;
            end = e;
            dur = d;
        }

        float at ( FrameAt f );
}

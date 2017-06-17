/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Preset;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.property.LimitedProperty,
       cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;

/+ プリセット関係をまとめた抽象クラス +/
abstract class PropertyPresets
{
    private:
        enum POS_MAX = 10000;
        enum POS_MIN = -10000;
        enum ROTATION_MAX = 360;
        enum ROTATION_MIN = -360;
    public:
        /+ 数値プロパティに関しては全てLimitedPropertyを使います +/

        /+ 位置指定プロパティ +/
        static void position ( PropertyList a, FrameLength f )
        {
            a["X"] = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
            a["Y"] = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
            a["Z"] = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
        }

        /+ 拡大率、アスペクト比指定プロパティ +/
        static void resize ( PropertyList a, FrameLength f )
        {
            a["Zoom"]   = new LimitedProperty!float( f, 0, 1000, 0 );
            a["Aspect"] = new LimitedProperty!float( f, 0, 100, -100 );
        }

        /+ 回転指定プロパティ +/
        static void rotation ( PropertyList a, FrameLength f )
        {
            a["RotationX"] = new LimitedProperty!float( f, 0, ROTATION_MAX, ROTATION_MIN );
            a["RotationY"] = new LimitedProperty!float( f, 0, ROTATION_MAX, ROTATION_MIN );
            a["RotationZ"] = new LimitedProperty!float( f, 0, ROTATION_MAX, ROTATION_MIN );
            a["CenterX"]   = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
            a["CenterY"]   = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
            a["CenterZ"]   = new LimitedProperty!float( f, 0, POS_MAX, POS_MIN );
        }
}

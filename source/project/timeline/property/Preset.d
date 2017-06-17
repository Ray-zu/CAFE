/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.property.Preset;
import cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;

/+ プリセット関係をまとめた抽象クラス +/
abstract class PropertyPresets
{
    public:

        /+ 位置指定プロパティ +/
        static void position ( PropertyList a, FrameLength f )
        {
            a["X"] = new PropertyBase!float( f, 0 );
            a["Y"] = new PropertyBase!float( f, 0 );
            a["Z"] = new PropertyBase!float( f, 0 );
        }

        /+ 回転指定プロパティ +/
        static void rotation ( PropertyList a, FrameLength f )
        {
            a["RotationX"] = new PropertyBase!float( f, 0 );
            a["RotationY"] = new PropertyBase!float( f, 0 );
            a["RotationZ"] = new PropertyBase!float( f, 0 );
            a["CenterX"]   = new PropertyBase!float( f, 0 );
            a["CenterY"]   = new PropertyBase!float( f, 0 );
            a["CenterZ"]   = new PropertyBase!float( f, 0 );
        }
}

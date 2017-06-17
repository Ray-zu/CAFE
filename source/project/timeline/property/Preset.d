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
    public:
        /+ 数値プロパティに関しては全てLimitedPropertyを使います +/

        /+ 位置指定プロパティ +/
        static void position ( PropertyList a, FrameLength f )
        {
            a["X"] = new LimitedProperty!float( f, 0 );
            a["Y"] = new LimitedProperty!float( f, 0 );
            a["Z"] = new LimitedProperty!float( f, 0 );
        }

        /+ 回転指定プロパティ +/
        static void rotation ( PropertyList a, FrameLength f )
        {
            a["RotationX"] = new LimitedProperty!float( f, 0 );
            a["RotationY"] = new LimitedProperty!float( f, 0 );
            a["RotationZ"] = new LimitedProperty!float( f, 0 );
            a["CenterX"]   = new LimitedProperty!float( f, 0 );
            a["CenterY"]   = new LimitedProperty!float( f, 0 );
            a["CenterZ"]   = new LimitedProperty!float( f, 0 );
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.TestObject;
import cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.PropertyKeepableObject;

class TestObject
{
    mixin PlaceableObject;
    mixin PropertyKeepableObject;

    unittest {
        auto hoge = new TestObject;
        auto huge = new Property!int( 0 );
    }
}

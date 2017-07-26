/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ConfigTabs;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!ConfigTabs );

/+ 左のプロパティ設定など +/
class ConfigTabs : TabWidget
{
    public:
        this ( string id = "" )
        {
            super( id );
        }
}

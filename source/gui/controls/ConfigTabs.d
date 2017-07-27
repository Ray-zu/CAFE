/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ConfigTabs;
import cafe.gui.controls.PropertyEditor;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!ConfigTabs );

/+ 左のプロパティ設定など +/
class ConfigTabs : TabWidget
{
    private:
        PropertyEditor pedit;

    public:
        @property propertyEditor () { return pedit; }

        this ( string id = "" )
        {
            super( id );
            pedit = new PropertyEditor("property_editor");
            addTab( pedit, "Property"d );
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ConfigTabs;
import cafe.gui.controls.ComponentTree,
       cafe.gui.controls.PropertyEditor;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!ConfigTabs );

/+ 左のプロパティ設定など +/
class ConfigTabs : TabWidget
{
    private:
        PropertyEditor pedit;
        ComponentTree  ctree;

    public:
        @property propertyEditor () { return pedit; }
        @property componentTree  () { return ctree; }

        this ( string id = "" )
        {
            super( id );
            pedit = new PropertyEditor("pedit");
            ctree = new ComponentTree ("ctree");
            addTab( pedit, "Property"d   );
            addTab( ctree, "Components"d );
        }

        override void measure ( int w, int h )
        {
            pedit.minHeight = h;
            ctree.minHeight = h;
            super.measure( w, h );
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.FragmentsExplorer;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!FragmentsExplorer );

/+ 素材一覧のリスト +/
class FragmentsExplorer : TreeWidget
{
    private:
        TreeItem local;
        TreeItem global;

    public:
        this ( string id = "" )
        {
            super( id );
            global = items.newChild( "GLOBAL", "Global Frags" );
            local  = items.newChild( "LOCAL" , "Loacl Frags"  );
        }
}

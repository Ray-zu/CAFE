/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.FragmentsExplorer;
import cafe.gui.Action;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!FragmentsExplorer );

/+ 素材一覧のリスト +/
class FragmentsExplorer : TreeWidget
{
    private:
        TreeItem local;
        TreeItem global;

    protected:
        override MenuItem onTreeItemPopupMenu ( TreeItems src, TreeItem sel )
        {
            MenuItem root = null;
            if ( sel is global || sel is local ) {
                with ( root = new MenuItem ) {
                    add( Action_AddFrag );
                    add( Action_AddFragDir  );
                }
            } else {
                auto parent = delegate ()
                {
                    auto cur = sel;
                    while ( cur.level == 0 )
                        cur = cur.parent;
                    return cur;
                }();
                root = onTreeItemPopupMenu( src, parent );
                root.addSeparator;
                with ( root = new MenuItem ) {
                    add( Action_RemoveFrag );
                }
            }
            selectItem( sel );
            return root;
        }

    public:
        this ( string id = "" )
        {
            super( id );
            styleId = "FRAGS_EXPLORER";
            global = items.newChild( "GLOBAL", "Global Frags" );
            local  = items.newChild( "LOCAL" , "Loacl Frags"  );
        }
}

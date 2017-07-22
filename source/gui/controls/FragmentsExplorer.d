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
    enum NodeType
    {
        Dir  = 100,
        Item
    }

    private:
        TreeItem local;
        TreeItem global;

        /+ iの上から二番目の親を返す +/
        auto secondNode ( TreeItem i )
        {
            while ( i.level > 1 )
                i = i.parent;
            return i;
        }

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
                root = onTreeItemPopupMenu( src, secondNode( sel ) );
                root.addSeparator;
                with ( root = new MenuItem ) {
                    add( Action_RemoveFrag );
                }
            }
            selectItem( sel );
            root.menuItemAction = &handleAction;
            return root;
        }

    public:
        this ( string id = "" )
        {
            super( id );
            styleId = "FRAGS_EXPLORER";

            global = items.newChild( "GLOBAL", "Global Frags" );
            local  = items.newChild( "LOCAL" , "Loacl Frags"  );
            global.intParam = NodeType.Dir;
            local .intParam = NodeType.Dir;
        }

        override bool handleAction ( const Action a )
        {
            import cafe.gui.Action;
            switch ( a.id ) {
                case EditorActions.AddFrag:
                    auto dir = items.selectedItem;
                    if ( dir.intParam != NodeType.Dir ) dir = dir.parent;
                    addWidgets( dir.newChild( "hoge", "hogeeee" ) );
                    updateWidgets;
                    return true;

                default:
            }
            return false;
        }
}

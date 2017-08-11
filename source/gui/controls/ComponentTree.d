/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ComponentTree;
import cafe.gui.Action,
       cafe.project.Project,
       cafe.project.ComponentList,
       cafe.project.Component;
import dlangui;

/+ コンポーネント一覧 +/
class ComponentTree : TreeWidget
{
    private:
        Project pro;

        TreeItem root;

    protected:
        override void updateWidgets ()
        {
            root.clear;
            if ( project ) {
                foreach ( k; pro.componentList.components.keys )
                    root.newChild( k, k.to!dstring );
            }
            super.updateWidgets;
        }

        override MenuItem onTreeItemPopupMenu ( TreeItems, TreeItem i )
        {
            MenuItem root = new MenuItem;
            if ( i.id == "" ) {
                root.add( Action_CompTreeAdd );
            } else if (  i.id != ComponentList.RootId ) {
                root.add( Action_CompTreeDelete );
            }
            root.add( Action_CompTreeConfig );

            selectItem( i );
            root.menuItemAction = &handleAction;
            return root;
        }

    public:
        @property project () { return pro; }
        @property project ( Project p )
        {
            pro = p;
            updateWidgets;
        }

        this ( string id = "" )
        {
            super( id );
            pro  = null;
            root = items.newChild( "", "Project"d );
        }

        override bool handleAction ( const Action a )
        {
            import cafe.gui.Action;

            switch ( a.id ) with( EditorActions ) {
                case CompTreeRefresh:
                    updateWidgets;
                    return true;

                case CompTreeAdd:
                    updateWidgets;
                    return true;

                case CompTreeConfig:
                    updateWidgets;
                    return true;

                case CompTreeDelete:
                    project.componentList.del( items.selectedItem.id );
                    updateWidgets;
                    return true;

                default: return super.handleAction( a );
            }
        }
}

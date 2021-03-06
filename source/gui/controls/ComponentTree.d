/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ComponentTree;
import cafe.gui.Action,
       cafe.gui.controls.ConfigDialogs,
       cafe.project.Project,
       cafe.project.ComponentList,
       cafe.project.Component;
import dlangui;

/+ コンポーネント一覧 +/
class ComponentTree : TreeWidget
{
    enum Style = "COMPONENT_TREE";
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
            if ( i.id != "" ) {
                if ( i.id != ComponentList.RootId )
                    root.add( Action_CompTreeDelete );
                root.add( Action_CompTreeOpen );
            } else {
                root.add( Action_CompTreeAdd );
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
            styleId = Style;

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
                    new ComponentConfigDialog( pro, "", window ).show;
                    return true;

                case CompTreeConfig:
                    auto id = items.selectedItem.id;
                    if ( id == "" )
                        new ProjectConfigDialog( false, window ).show;
                    else new ComponentConfigDialog( pro, id, window ).show;
                    return true;

                case CompTreeDelete:
                    project.componentList.del( items.selectedItem.id );
                    updateWidgets;
                    return true;

                case CompTreeOpen:
                    return window.mainWidget.handleAction( a );

                default: return super.handleAction( a );
            }
        }
}

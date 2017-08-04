/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.Chooser;
import dlangui,
       dlangui.dialogs.dialog;

class Chooser : Dialog
{
    enum DlgWidth  = 400;
    enum DlgHeight = 600;
    enum DlgFlag = DialogFlag.Popup;

    enum SearchLayout = q{
       HorizontalLayout {
           ImageWidget {
               id:search_icon;
               drawableId:zoom;
               alignment:VCenter;
               margins:3;
           }
           EditLine { id:search }
       }
    };

    protected:
        ImageWidget search_icon;
        EditLine    search;
        ListWidget  list;

        WidgetListAdapter adapter;

        /+ オーバーライドして検索文字列にマッチするアイテムを追加 +/
        void updateSearchResult ( EditableContent = null )
        {
            adapter.clear;
        }

    public:
        this ( UIString c, Window w = null )
        {
            super( c, w, DlgFlag, DlgWidth, DlgHeight );
            addChild( parseML( SearchLayout ) );

            search_icon = cast(ImageWidget) childById( "search_icon" );
            search      = cast(EditLine   ) childById( "search"      );

            search.contentChange = &updateSearchResult;

            list    = cast(ListWidget) addChild( new ListWidget );
            adapter = new WidgetListAdapter;
            list.ownAdapter = adapter;

            updateSearchResult;
            show;
        }

        override void measure ( int w, int h )
        {
            search.minWidth = DlgWidth  - search_icon.width;
            list.minHeight  = DlgHeight - search.height;
            super.measure( w, h );
        }
}

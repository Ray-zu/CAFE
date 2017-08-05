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

        ScrollWidget scroll;
        TableLayout  list;

        /+ オーバーライドして検索文字列にマッチするアイテムを追加 +/
        void updateSearchResult ( EditableContent = null )
        {
            list.removeAllChildren;
            foreach ( i; 0 .. 100 )
                list.addChild( new ChooserItem( "hogee" ) );
        }

    public:
        this ( UIString c, Window w = null )
        {
            super( c, w, DlgFlag, DlgWidth, DlgHeight );
            addChild( parseML( SearchLayout ) );

            search_icon = cast(ImageWidget) childById( "search_icon" );
            search      = cast(EditLine   ) childById( "search"      );
            search.contentChange = &updateSearchResult;

            scroll = cast(ScrollWidget) addChild( new ScrollWidget );
            list   = cast(TableLayout ) scroll.addChild( new TableLayout );
            scroll.contentWidget = list;

            updateSearchResult;
            show;
        }

        override void measure ( int w, int h )
        {
            search.minWidth = DlgWidth  - search_icon.width;
            scroll.minHeight  = DlgHeight - search.height;
            super.measure( w, h );

            if ( w != SIZE_UNSPECIFIED )
                list.colCount = w / ChooserItem.Width;
        }
}

class ChooserItem : VerticalLayout
{
    enum Style  = "CHOOSER_ITEM";
    enum Width  = 100;
    enum Height = 100;

    private:
        ImageWidget icon;
        TextWidget  name;

    public:
        this ( string t, string i = "obj_ctg_others" )
        {
            super( t );
            styleId   = Style;
            minWidth  = Width;
            minHeight = Height;
            maxWidth  = Width;
            maxHeight = Height;
            layoutHeight = FILL_PARENT;

            trackHover = true;
            focusable  = true;
            clickable  = true;

            addChild( new VSpacer );
            icon = cast(ImageWidget) addChild( new ImageWidget( "", i ) );
            name = cast(TextWidget ) addChild( new TextWidget ( "", t.to!dstring ) );
            addChild( new VSpacer );

            icon.alignment = Align.HCenter;
            name.alignment = Align.HCenter;
        }
}

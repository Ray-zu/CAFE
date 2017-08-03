/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.Chooser;
import cafe.project.timeline.PlaceableObject;
import std.algorithm,
       std.array,
       std.conv,
       std.string;
import dlangui,
       dlangui.dialogs.dialog;

/+ リストから選択するダイアログ +/
class Chooser : Dialog
{
    enum DlgWidth  = 400;
    enum DlgHeight = 500;
    enum DlgFlag   = DialogFlag.Popup;
    enum Layout    = q{
        VerticalLayout {
            HorizontalLayout {
                EditLine { id:search_box }
            }

            TextWidget { text:"Searching Result" }
        }
    };

    protected:
        EditLine     search_box;
        ScrollWidget main;
        TableLayout  list;

        void updateWidgets ()
        {
            list.removeAllChildren;
            auto sw = search_box.text;
            auto results = sw == "" ?
                items:
                items.filter!( x => x.text.indexOf( sw ) >= 0 ).array;
            results.each!( x => list.addChild(x) );
        }

    public:
        @property ChooserItem[] items () { return []; }

        this ( string cap, Window p = null )
        {
            super( UIString.fromRaw(cap), p, DlgFlag, DlgWidth, DlgHeight );

            with ( addChild( new VerticalLayout ) ) {
                search_box = cast(EditLine    ) addChild( new EditLine );
                main       = cast(ScrollWidget) addChild( new ScrollWidget );
            }
            list = cast(TableLayout) main.addChild( new TableLayout );

            search_box.minWidth = DlgWidth;
            search_box.contentChange = delegate ( EditableContent e )
            {
                updateWidgets;
            };
            main.minHeight = DlgHeight - search_box.height;

            //updateWidgets;
            show;
        }
}

/+ Chooserのアイテム +/
private class ChooserItem : VerticalLayout
{
    enum ItemSize = 150;

    private:
        ImageWidget icon;
        TextWidget  name;

    public:
        this ( string n, string i = "" )
        {
            super( n );
            layoutHeight = FILL_PARENT;
            text = n.to!dstring;

            addChild( new VSpacer );
            icon = cast(ImageWidget) addChild( new ImageWidget( "", i ) );
            name = cast(TextWidget ) addChild( new TextWidget ( "", n ) );
            addChild( new VSpacer );
        }

        override void measure ( int w, int h )
        {
            measuredContent( w, h, ItemSize, ItemSize );
        }
}

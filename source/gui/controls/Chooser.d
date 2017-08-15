/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.Chooser;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.effect.Effect,
       cafe.gui.Action;
import std.string;
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

            addChild( createButtonsPanel( [ACTION_CANCEL], 0, true ) );

            updateSearchResult;
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

        override uint getCursorType ( int x, int y )
        {
            return CursorType.Hand;
        }
}

/+ オブジェクト選択ダイアログ +/
class ObjectChooser : Chooser
{
    private:
        Timeline          timeline;
        ObjectPlacingInfo opi;

    protected:
        override void updateSearchResult ( EditableContent = null )
        {
            super.updateSearchResult;
            auto word = search.text;
            foreach ( i; PlaceableObject.registeredObjects ) {
                if ( i.name != "" && i.name.indexOf( word ) == -1 ) continue;

                auto item = list.addChild( new ChooserItem(i.name, i.icon) );
                item.click = delegate ( Widget w )
                {
                    timeline += i.createAt(opi);
                    window.mainWidget.handleAction( Action_ObjectRefresh );
                    window.mainWidget.handleAction( Action_TimelineRefresh );
                    close( null );
                    return true;
                };
            }
        }

    public:
        this ( uint f, uint l, Timeline t, Window w = null )
        {
            timeline = t;

            auto layer  = new LayerId( l );
            auto frame  = new FrameAt( f );
            auto length = new FrameLength( 1 );
            opi = new ObjectPlacingInfo( layer,
                    new FramePeriod( timeline.length, frame, length ) );
            super( UIString.fromRaw("Choose Object"), w );
        }
}

/+ エフェクト追加 +/
class EffectChooser : Chooser
{
    private:
        PlaceableObject obj;

    protected:
        override void updateSearchResult ( EditableContent = null )
        {
            super.updateSearchResult;
            auto word = search.text;
            list.removeAllChildren;
            foreach ( i; Effect.registeredEffects ) {
                if ( word != "" && i.name.indexOf( word ) == -1 ) continue;

                auto item = list.addChild( new ChooserItem( i.name, i.icon ) );
                item.click = delegate ( Widget w )
                {
                    obj.effectList += i.createNew( obj.place.frame.length );
                    window.mainWidget.handleAction( Action_ObjectRefresh );
                    window.mainWidget.handleAction( Action_TimelineRefresh );
                    close( null );
                    return true;
                };
            }
        }

    public:
        this ( PlaceableObject o, Window w = null )
        {
            obj = o;
            super( UIString.fromRaw("Choose Effect"), w );
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyEditor;
import cafe.project.ObjectPlacingInfo,
       cafe.project.Project,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.project.timeline.property.PropertyList,
       cafe.project.timeline.effect.Effect,
       cafe.project.timeline.effect.EffectList,
       cafe.gui.Action,
       cafe.gui.controls.Chooser;
import std.algorithm,
       std.conv,
       std.string;
import dlangui,
       dlangui.widgets.metadata,
       dlangui.dialogs.dialog;

mixin( registerWidgets!PropertyEditor );

/+ プロパティを編集するウィジェット +/
class PropertyEditor : ScrollWidget
{
    private:
        Project pro;

        VerticalLayout main;

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
            layoutWidth  = FILL_PARENT;
            layoutHeight = FILL_PARENT;
            styleId = "PROPERTY_EDITOR";
            hscrollbarMode = ScrollBarMode.Invisible;

            main = cast(VerticalLayout) addChild( new VerticalLayout );
            contentWidget = main;
        }

        void updateWidgets ()
        {
            if ( !project ) return;
            auto obj = project.selectingObject;

            main.removeAllChildren;
            if ( obj ) {
                auto f = project.componentList.selecting.timeline.frame.value.to!int -
                    obj.place.frame.start.value.to!int;
                f = min( obj.place.frame.length.value.to!int-1, max( 0, f ) );

                auto fat = new FrameAt( f.to!uint );
                main.addChild( new ObjectGroupPanelFrame( obj, fat, window ) );
                obj.effectList.effects.each!
                    ( x => main.addChild( new EffectGroupPanelFrame( x, obj.effectList, fat, window ) ) );
            }
            main.invalidate;
        }

        override void measure ( int w, int h )
        {
            main.minWidth = w - vscrollbar.width;
            super.measure( w, h );
        }
}

/+ 一つのグループの外枠 +/
private abstract class GroupPanelFrame : VerticalLayout
{
    enum HeaderLayout = q{
        HorizontalLayout {
            id:main;
            layoutWidth:FILL_PARENT;
            styleId:PROPERTY_EDITOR_GROUP_HEADER;
            HSpacer {}
            TextWidget { id:header; fontSize:16; alignment:VCenter }
            HSpacer {}
        }
    };

    class CustomButton : ImageButton
    {
        this ( string icon )
        {
            super( "", icon );
            alignment = Align.VCenter;
            styleId = "PROPERTY_EDITOR_HEADER_BUTTON";
        }
    }

    protected:
        PropertyPanel panel;

    public:
        this ( PropertyList l, string title, FrameAt f )
        {
            super();
            margins = Rect( 5, 5, 5, 5 );
            padding = Rect( 5, 5, 5, 5 );

            addChild( parseML(HeaderLayout) );
            panel = cast(PropertyPanel)addChild( new PropertyPanel( l, f ) );

            childById( "header" ).text = title.to!dstring;
        }
}

/+ オブジェクト用外枠 +/
private class ObjectGroupPanelFrame : GroupPanelFrame
{
    public:
        this ( PlaceableObject o, FrameAt f, Window w )
        {
            super( o.propertyList, o.name, f );
            childById("main").addChild( new CustomButton( "new" ) )
                .click = delegate ( Widget w )
                {
                    new EffectChooser( o , window ).show;
                    return true;
                };
        }
}

/+ エフェクト用外枠 +/
private class EffectGroupPanelFrame : GroupPanelFrame
{
    public:
        // イベント送信用にウィンドウも渡す
        this ( Effect e, EffectList el, FrameAt f, Window w )
        {
            super( e.propertyList, e.name, f );

            void update ( bool edit = true )
            {
                if ( edit )
                    w.mainWidget.handleAction( Action_PreviewRefresh );
                w.mainWidget.handleAction( Action_ObjectRefresh );
                w.mainWidget.handleAction( Action_TimelineRefresh );
            }
            auto main = childById( "main" );

            main.addChild( new CustomButton( "up" ) )
                .click = delegate ( Widget w )
                {
                    el.up( e ); update;
                    return true;
                };
            main.addChild( new CustomButton( "down" ) )
                .click = delegate ( Widget w )
                {
                    el.down( e ); update;
                    return true;
                };
            main.addChild( new CustomButton( e.enable ? "visible" : "invisible" ) )
                .click = delegate ( Widget w )
                {
                    e.enable = !e.enable;
                    (cast(ImageWidget)w).drawableId =
                        e.enable ? "visible" : "invisible";
                    update;
                    return true;
                };
            main.addChild( new CustomButton( "quit" ) )
                .click = delegate ( Widget w )
                {
                    el.remove( e );
                    update;
                    return true;
                };
            // エフェクトプロパティ表示 or 非表示
            alignment( Align.VCenter )
                .clickable( true )
                .click = delegate ( Widget w )
                {
                    e.propertiesOpened = !e.propertiesOpened;
                    panel.visibility = e.propertiesOpened ?
                        Visibility.Visible : Visibility.Gone;
                    update( false );
                    return true;
                };
            panel.visibility = e.propertiesOpened ?
                Visibility.Visible : Visibility.Gone;
        }
}

/+ プロパティ編集 +/
private class PropertyPanel : VerticalLayout
{
    private:
        PropertyList props;
        FrameAt frame;

        void addProperty ( Property p, string name )
        {
            addChild( new TextWidget( "", name.to!dstring ) );

            auto l = addChild( new HorizontalLayout );
            l.layoutWidth = FILL_PARENT;
            l.addChild( new HSpacer );
            auto input = cast(EditWidgetBase)l.addChild( p.allowMultiline ?
                    new EditBox( name ) : new EditLine( name ) );
            l.addChild( new HSpacer );

            input.styleId  = "PROPERTY_EDITOR_INPUT";
            input.minWidth = 200;
            if ( p.allowMultiline )
                input.minHeight = 100;
            else {
                input.padding = Rect( 2,2,2,2 );
            }
            input.text = p.getString( frame ).to!dstring;

            input.focusChange = delegate ( Widget w, bool f )
            {
                auto new_text = p.getString( frame ).to!dstring;
                if ( input.text != new_text ) input.text = new_text;
                return true;
            };
            input.contentChange = delegate ( EditableContent e )
            {
                auto new_text = input.text.to!string;
                auto now_text = p.getString( frame );
                try {
                    if ( new_text != now_text )
                        p.setString( frame, new_text );
                } catch ( Exception e ) {
                    input.text = now_text.to!dstring;
                }
            };
        }

    public:
        this ( PropertyList p, FrameAt f )
        {
            super();
            props = p;
            frame = f;
            updateWidgets;
        }

        void updateWidgets ()
        {
            removeAllChildren;
            foreach ( k,v; props.properties )
                addProperty( v, k );
            invalidate;
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

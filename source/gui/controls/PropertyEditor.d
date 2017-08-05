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
       cafe.gui.controls.Chooser;
import std.algorithm,
       std.conv,
       std.string;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!PropertyEditor );

/+ プロパティを編集するウィジェット +/
class PropertyEditor : ScrollWidget
{
    private:
        Project pro;

        PlaceableObject cached_obj = null;
        uint cached_frame = 0;

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

            auto upflag = cached_obj !is project.selectingObject;
            cached_obj = project.selectingObject;

            if ( cached_obj ) {
                auto f = project.componentList.selecting.timeline.frame.value.to!int -
                    cached_obj.place.frame.start.value.to!int;
                f = min( cached_obj.place.frame.length.value.to!int-1, max( 0, f ) );
                upflag = upflag || f != cached_frame;
                cached_frame = f;

                if ( upflag ) {
                    auto fat = new FrameAt( f.to!uint );
                    main.removeAllChildren;
                    main.addChild( new GroupPanelFrame( cached_obj.propertyList, cached_obj.name, fat ) );
                    cached_obj.effectList.effects.each!
                        ( x => main.addChild( new GroupPanelFrame( x.propertyList, x.name, fat ) ) );
                }
            } else main.removeAllChildren;
            main.invalidate;
        }

        override bool onMouseEvent ( MouseEvent e )
        {
            auto result = false;
            auto obj    = project.selectingObject;
            if ( e.button == MouseButton.Right && e.action == MouseAction.ButtonDown ) {
                if ( obj ) new EffectChooser( obj , window );
            }
            return super.onMouseEvent( e ) || result;
        }

        override void measure ( int w, int h )
        {
            main.minWidth = w - vscrollbar.width;
            super.measure( w, h );
        }
}

/+ 一つのグループの外枠 +/
private class GroupPanelFrame : VerticalLayout
{
    enum HeaderLayout = q{
        HorizontalLayout {
            layoutWidth:FILL_PARENT;
            styleId:PROPERTY_EDITOR_GROUP_HEADER;
            HSpacer {}
            TextWidget { id:header; fontSize:16 }
            HSpacer {}
            ImageWidget { id:shrink; drawableId:move_behind; }
        }
    };

    private:
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
            childById( "shrink" ).mouseEvent = delegate ( Widget w, MouseEvent e )
            {
                if ( e.action == MouseAction.ButtonDown && e.button & MouseButton.Left ) {
                    panel.visibility = panel.visibility == Visibility.Visible ?
                        Visibility.Gone : Visibility.Visible;
                    invalidate;
                    return true;
                } else return false;
            };
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
            input.contentChange = delegate ( EditableContent e )
            {
                p.setString( frame, e.text.to!string );
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
                if ( word != "" && i.name.indexOf( word ) >= 0 ) continue;

                auto item = list.addChild( new ChooserItem( i.name, i.icon ) );
                item.click = delegate ( Widget w )
                {
                    obj.effectList += i.createNew( obj.place.frame.length );
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

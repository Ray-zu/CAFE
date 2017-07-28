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
       cafe.project.timeline.property.PropertyList;
import std.algorithm,
       std.conv;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!PropertyEditor );

/+ プロパティを編集するウィジェット +/
class PropertyEditor : VerticalLayout
{
    private:
        Project pro;

        PlaceableObject cached_obj = null;
        uint cached_frame = 0;

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
        }

        void updateWidgets ()
        {
            if ( !project ) return;

            auto upflag = cached_obj !is project.selectingObject;
            cached_obj = project.selectingObject;

            if ( cached_obj ) {
                auto f = project.componentList.selecting.timeline.frame.value -
                    cached_obj.place.frame.start.value;
                f = max( cached_obj.place.frame.end.value-1, min( 0, f ) );
                upflag = upflag || f == cached_frame;
                cached_frame = f;

                if ( upflag ) {
                    auto fat = new FrameAt( f );
                    removeAllChildren;
                    addChild( new GroupPanelFrame( cached_obj.propertyList, cached_obj.name, fat ) );
                    cached_obj.effectList.effects.each!
                        ( x => addChild( new GroupPanelFrame( x.propertyList, x.name, fat ) ) );
                    invalidate;
                }
            }
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

            input.minWidth = 200;
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

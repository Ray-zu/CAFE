/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyEditor;
import cafe.project.ObjectPlacingInfo,
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
        PlaceableObject obj;
        GroupPanelFrame[] panels;

    public:
        @property curFrame ( FrameAt f ) { panels.each!( x => x.curFrame = f ); }

        this ( string id = "" )
        {
            super( id );
            obj = null;
            panels = [];
        }
}

/+ 一つのグループの外枠 +/
private class GroupPanelFrame : VerticalLayout
{
    enum HeaderLayout = q{
        HorizontalLayout {
            layoutWidth:FILL_PARENT;
            TextWidget { id:header; styleId:PROPERTY_EDITOR_GROUP_HEADER }
            HSpacer {}
            ImageButton { id:shrink; drawableId:move_behind }
        }
    };

    private:
        PropertyPanel panel;

    public:
        @property curFrame ( FrameAt f ) { panel.frame = f; }

        this ( PropertyList l, string title, FrameAt f )
        {
            super();
            addChild( parseML(HeaderLayout) );
            childById( "header" ).text = title.to!dstring;

            panel = cast(PropertyPanel)addChild( new PropertyPanel( l, f ) );
        }
}

/+ プロパティ編集 +/
private class PropertyPanel : VerticalLayout
{
    private:
        PropertyList props;

        void addProperty ( Property p, string name )
        {
            addChild( new TextWidget( "", name.to!dstring ) );
            auto input = cast(EditWidgetBase)addChild( p.allowMultiline ?
                    new EditLine( name ) : new EditBox( name ) );
            input.text = p.getString( frame ).to!dstring;
            input.contentChange = delegate ( EditableContent e )
            {
                p.setString( frame, e.text.to!string );
            };
        }

    public:
        FrameAt frame;

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

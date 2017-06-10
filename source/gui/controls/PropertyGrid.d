/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyGrid;
import cafe.project.timeline.property.PropertyList,
       cafe.project.ObjectPlacingInfo,
       cafe.gui.controls.PropertyEditBox;
import std.conv,
       std.string;
import dlangui;

/+ プロパティグリッド +/
class PropertyGrid : StringGridWidget
{
    public:
        enum RowHeight = 20;

    private:
        PropertyList props;
        FrameAt      current_frame;

    public:
        @property propertyList () { return props; }
        @property propertyList ( PropertyList p )
        {
            props = p;
            gridUpdate;
        }

        @property frame () { return current_frame; }
        @property frame ( FrameAt f )
        {
            current_frame = f;
            gridUpdate;
        }

        this ( string id = "PropertyGrid" )
        {
            super( id );
            props = null;
            frame = new FrameAt( 0 );

            layoutWidth( FILL_PARENT ).layoutHeight( FILL_PARENT );
            defRowHeight = RowHeight;
            hscrollbarMode = ScrollBarMode.Invisible;
            vscrollbarMode = ScrollBarMode.Auto;

            cellActivated = delegate( GridWidgetBase w, int c, int r )
            {
                (cast(PropertyGrid)w).edit( c, r );
            };
        }

        override void autoFit ()
        {
            for ( auto i = 0; i < rows+1; i++ )
                setRowHeight( i, RowHeight );
        }

        /+ propertyListに従ってグリッドを更新 +/
        void gridUpdate ( FrameAt f = null )
        {
            if ( f ) current_frame = f;

            if ( propertyList ) {
                resize( 1, propertyList.properties.length.to!int );
                auto index = 0;
                foreach ( key,val; propertyList.properties )
                {
                    setRowTitle( index, key.to!dstring );
                    setCellText( 0, index, val.getString(current_frame)
                            .tr("\n","\\").to!dstring );
                    index++;
                }
                visibility = Visibility.Visible;
            } else {
                visibility = Visibility.Gone;
            }
            autoFit;
        }

        void edit ( int c, int r )
        {
            auto handler = delegate ()
            {
                gridUpdate;
            };

            (new PropertyEditBox( propertyList.properties.values[r], frame, window, handler )).show;
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyGrid;
import cafe.project.timeline.property.PropertyList,
       cafe.project.ObjectPlacingInfo;
import std.conv;
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

            // テストコード
            import cafe.project.ObjectPlacingInfo,
                   cafe.project.timeline.property.Property;
            auto plist = new PropertyList;
            auto fl = new FrameLength(20);
            plist["X"] = new PropertyBase!float( fl, 0.0 );
            plist["Y"] = new PropertyBase!float( fl, 0.0 );
            plist["Z"] = new PropertyBase!float( fl, 0.0 );
            propertyList = plist;
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
                resize( 1, propertyList.properties.length );
                auto index = 0;
                foreach ( key,val; propertyList.properties )
                {
                    setRowTitle( index, key.to!dstring );
                    setCellText( 0, index, val.getString(current_frame).to!dstring );
                    index++;
                }
                visibility = Visibility.Visible;
            } else {
                visibility = Visibility.Gone;
            }
            autoFit;
        }
}

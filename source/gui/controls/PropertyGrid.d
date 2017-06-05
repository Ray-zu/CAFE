/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyGrid;
import cafe.project.timeline.property.PropertyList;
import dlangui;

/+ プロパティグリッド +/
class PropertyGrid : StringGridWidget
{
    private:
        PropertyList props;

    public:
        @property propertyList () { return props; }
        @property propertyList ( PropertyList p )
        {
            props = p;
            gridUpdate;
        }

        this ( string id = "PropertyGrid" )
        {
            super( id );
            layoutWidth( FILL_PARENT ).layoutHeight( FILL_PARENT );
            propertyList = null;
        }

        /+ propertyListに従ってグリッドを更新 +/
        void gridUpdate ()
        {
            if ( propertyList ) {
                resize( 1, propertyList.properties.length );
                enabled = true;

            } else {
                resize( 1, 1 );
                setCellText( 0, 0, "" );
                enabled = false;
            }
            autoFit;
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.ObjectChooser;
import cafe.gui.controls.Chooser,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject;
import std.string;
import dlangui;

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

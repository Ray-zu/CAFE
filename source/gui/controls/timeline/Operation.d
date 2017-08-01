/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Operation;
import cafe.project.Project,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.gui.controls.timeline.Cache,
       cafe.gui.controls.timeline.Line;
import dlangui;

/+ タイムラインイベントのデータ受け渡しクラス +/
class Operation 
{
    enum State {
        None,
        Clicking,
        Dragging
    }

    private:
        Cache cache;
        State state;

        PlaceableObject operating_object   = null;
        Property        operating_property = null;

        void moveObj ( uint f, uint l )
        {
            auto line = cache.lines[l];
            auto obj  = operating_object;

            if ( line.layerIndex == -1 )
                moveObj( f, l+1 );
            else {
                obj.place.frame.move( new FrameAt( f ) );
                obj.place.layer.value = l;
            }
        }

        auto moveProp ( uint f, uint l )
        {
            auto line = cache.lines[l];
            auto prop = operating_property;
            // TODO
        }

    public:
        @property isOperating ()
        {
            return state != State.None;
        }

        this ( Cache c )
        {
            cache = c;
            state = State.None;
        }

        auto clear ()
        {
            state              = State.None;
            operating_object   = null;
            operating_property = null;
        }

        auto clicking ()
        {
            state = State.Clicking;
        }

        auto move ( uint f, uint l )
        {
            if ( state == State.Clicking ) state = State.Dragging;
            if ( state == State.Dragging ) {
                if ( operating_object   ) moveObj ( f, l );
                if ( operating_property ) moveProp( f, l );
            }
        }
}

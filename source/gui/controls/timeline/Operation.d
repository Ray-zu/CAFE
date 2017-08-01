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

        void moveObj ( uint f, uint l )
        {
            auto line = cache.lines[l];
            auto obj  = operatingObject;
            auto rf   = f.to!int - frameOffset;

            if ( line.layerIndex == -1 )
                moveObj( f, l+1 );
            else {
                obj.place.frame.move( new FrameAt( rf ) );
                obj.place.layer.value = l;
                cache.updateLinesCache;
            }
        }

        auto moveProp ( uint f, uint l )
        {
            auto line = cache.lines[l];
            auto prop = operatingProperty;
            // TODO
        }

    public:
        PlaceableObject operatingObject   = null;
        Property        operatingProperty = null;

        int frameOffset = 0;

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
            state             = State.None;
            operatingObject   = null;
            operatingProperty = null;
            frameOffset = 0;
        }

        auto clicking ()
        {
            state = State.Clicking;
        }

        auto move ( uint f, uint l )
        {
            if ( state == State.Clicking ) state = State.Dragging;
            if ( state == State.Dragging ) {
                if ( operatingObject   ) moveObj ( f, l );
                if ( operatingProperty ) moveProp( f, l );
            }
        }

        auto release ( uint f )
        {
            if ( state == State.Clicking ) {
                if ( operatingObject ) {
                    cache.timeline.selecting = cache.timeline
                        .selecting is operatingObject ? null : operatingObject;
                }
            }
            clear;
        }
}

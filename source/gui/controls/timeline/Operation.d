/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Operation;
import cafe.project.Project,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
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
        Timeline timeline;
        State    state;

        PlaceableObject operating_object   = null;
        Property        operating_property = null;
        bool            operated           = false;

    public:
        @property isOperating ()
        {
            return operating_object || operating_property || operated;
        }

        this ( Timeline tl )
        {
            timeline = tl;
            state = State.None;
        }

        auto clear ()
        {
            operating_object   = null;
            operating_property = null;
            operated           = false;
        }

        auto processed ()
        {
            operated = true;
        }
}

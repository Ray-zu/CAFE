/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Action;
import dlangui;

enum TimelineActions : int
{
    Dlg_AddObject = 20000,

    RmObject
}

/+ フレーム数とラインインデックスを指定できるアクション +/
private template PointAction ( alias ID, string LABEL, string ICON )
{
    public:
        uint frame;
        uint line;

        this ( uint f, uint l )
        {
            super( cast(int)ID, LABEL, ICON );
            frame = f;
            line  = l;
        }
}

class Action_Dlg_AddObject : Action {
    mixin PointAction!( TimelineActions.Dlg_AddObject, "Timeline_AddObject", "new" );
}

class Action_RmObject : Action {
    mixin PointAction!( TimelineActions.RmObject, "Timeline_RmObject", "quit" );
}

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
    LinesRefresh = 20000,

    Dlg_AddObject,
    Dlg_AddEffect,

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

class Action_Dlg_AddEffect : Action {
    mixin PointAction!( TimelineActions.Dlg_AddEffect, "Timeline_AddEffect", "new" );
}

class Action_RmObject : Action {
    mixin PointAction!( TimelineActions.RmObject, "Timeline_RmObject", "quit" );
}

const Action_UpEffect   = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_UpEffect" );
const Action_DownEffect = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_DownEffect" );
const Action_RmEffect   = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_RmEffect", "quit" );

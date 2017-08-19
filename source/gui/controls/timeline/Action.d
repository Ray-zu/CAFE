/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Action;
import cafe.project.timeline.property.Property;
import dlangui;

enum TimelineActions : int
{
    LinesRefresh = 20000,

    Dlg_AddObject,
    Dlg_AddEffect,
    Dlg_EaseMiddlePoint,

    SetLastFrame,

    RmObject,

    RmMiddlePoint
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

/+ プロパティと中間点のインデックスを指定できるアクション +/
private template PropertyAction ( alias ID, string LABEL, string ICON )
{
    public:
        Property property;
        uint mpIndex;

        this ( Property p, uint m )
        {
            super( cast(int)ID, LABEL, ICON );
            property = p;
            mpIndex  = m;
        }
}

class Action_Dlg_AddObject : Action {
    mixin PointAction!( TimelineActions.Dlg_AddObject, "Timeline_AddObject", "new" );
}

class Action_Dlg_AddEffect : Action {
    mixin PointAction!( TimelineActions.Dlg_AddEffect, "Timeline_AddEffect", "new" );
}

class Action_Dlg_EaseMiddlePoint : Action {
    mixin PropertyAction!( TimelineActions.Dlg_EaseMiddlePoint, "Timeline_EaseMiddlePoint", "config" );
}

class Action_SetLastFrame : Action {
    mixin PointAction!( TimelineActions.SetLastFrame, "Timeline_SetLastFrame", "shift_ahead" );
}

class Action_RmObject : Action {
    mixin PointAction!( TimelineActions.RmObject, "Timeline_RmObject", "quit" );
}

class Action_RmMiddlePoint : Action {
    mixin PropertyAction!( TimelineActions.RmMiddlePoint, "Timeline_RmMiddlePoint", "quit" );
}

const Action_UpEffect   = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_UpEffect", "up" );
const Action_DownEffect = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_DownEffect", "down" );
const Action_RmEffect   = new Action( cast(int) TimelineActions.LinesRefresh, "Timeline_RmEffect", "quit" );

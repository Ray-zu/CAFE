/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.Action;
import dlangui;

enum EditorActions : int
{
    UpdateStatus = 10000,

    ProjectNew,
    ProjectOpen,
    ProjectSave,
    ProjectSaveAs,
    ProjectClose,
    ProjectExit,

    Play,
    Pause,
    Stop,
    MoveBehind,
    MoveAHead,
    ShiftBehind,
    ShiftAHead,

    ProjectRefresh,
    PreviewRefresh,
    ObjectRefresh,
    CompTreeRefresh,
    TimelineRefresh,

    ChangeFrame,

    CompTreeAdd,
    CompTreeConfig,
    CompTreeDelete,
    CompTreeOpen,

    VersionDlg,
    HomePage
}

class Action_UpdateStatus : Action
{
    public:
        this ( T ) ( T t )
        {
            super( cast(int)EditorActions.UpdateStatus, t );
        }
}

const Action_ProjectNew    = new Action( cast(int)EditorActions.ProjectNew   , "ProjectNew"   , "new" );
const Action_ProjectOpen   = new Action( cast(int)EditorActions.ProjectOpen  , "ProjectOpen"  , "open" );
const Action_ProjectSave   = new Action( cast(int)EditorActions.ProjectSave  , "ProjectSave"  , "save" );
const Action_ProjectSaveAs = new Action( cast(int)EditorActions.ProjectSaveAs, "ProjectSaveAs", "save_again" );
const Action_ProjectClose  = new Action( cast(int)EditorActions.ProjectClose , "ProjectClose" , "quit" );

const Action_Play        = new Action( cast(int)EditorActions.Play       , "Play"       , "play"         );
const Action_Pause       = new Action( cast(int)EditorActions.Pause      , "Pause"      , "pause"        );
const Action_Stop        = new Action( cast(int)EditorActions.Stop       , "Stop"       , "stop"         );
const Action_MoveBehind  = new Action( cast(int)EditorActions.MoveBehind , "MoveBehind" , "move_behind"  );
const Action_MoveAHead   = new Action( cast(int)EditorActions.MoveAHead  , "MoveAHead"  , "move_ahead"   );
const Action_ShiftBehind = new Action( cast(int)EditorActions.ShiftBehind, "ShiftBehind", "shift_behind" );
const Action_ShiftAHead  = new Action( cast(int)EditorActions.ShiftAHead , "ShiftAHead" , "shift_ahead"  );

const Action_ProjectRefresh  = new Action( cast(int)EditorActions.ProjectRefresh , "ProjectRefresh"  );
const Action_PreviewRefresh  = new Action( cast(int)EditorActions.PreviewRefresh , "PreviewRefresh"  );
const Action_ObjectRefresh   = new Action( cast(int)EditorActions.ObjectRefresh  , "ObjectRefresh"   );
const Action_CompTreeRefresh = new Action( cast(int)EditorActions.CompTreeRefresh, "CompTreeRefresh" );
const Action_TimelineRefresh = new Action( cast(int)EditorActions.TimelineRefresh, "TimelineRefresh" );

const Action_ChangeFrame = new Action( cast(int)EditorActions.ChangeFrame, "ChangeFrame" );

const Action_CompTreeAdd    = new Action( cast(int)EditorActions.CompTreeAdd   , "CompTreeAdd"   , "new"    );
const Action_CompTreeConfig = new Action( cast(int)EditorActions.CompTreeConfig, "CompTreeConfig", "config" );
const Action_CompTreeDelete = new Action( cast(int)EditorActions.CompTreeDelete, "CompTreeDelete", "quit"   );
const Action_CompTreeOpen   = new Action( cast(int)EditorActions.CompTreeOpen  , "CompTreeOpen"  , "open"   );

const Action_VersionDlg = new Action( cast(int)EditorActions.VersionDlg, "VersionDialog" );
const Action_HomePage   = new Action( cast(int)EditorActions.HomePage  , "HomePage" );

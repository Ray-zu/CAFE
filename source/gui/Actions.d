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
    ProjectNew = 10000,
    ProjectOpen,
    ProjectSave,
    ProjectSaveAs,
    ProjectClose,
    ProjectExit
}

const Action_ProjectNew    = new Action( cast(int)EditorActions.ProjectNew   , "ProjectNew"    );
const Action_ProjectOpen   = new Action( cast(int)EditorActions.ProjectOpen  , "ProjectOpen"   );
const Action_ProjectSave   = new Action( cast(int)EditorActions.ProjectSave  , "ProjectSave"  , "save" );
const Action_ProjectSaveAs = new Action( cast(int)EditorActions.ProjectSaveAs, "ProjectSaveAs", "save_again" );
const Action_ProjectClose  = new Action( cast(int)EditorActions.ProjectClose , "ProjectClose"  );

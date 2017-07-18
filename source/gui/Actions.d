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
    FileNew = 10000,
    FileOpen,
    FileSave,
    FileSaveAs,
    FileClose,
    FileExit
}

const Action_FileNew    = new Action( cast(int)EditorActions.FileNew   , "FileNew"    );
const Action_FileOpen   = new Action( cast(int)EditorActions.FileOpen  , "FileOpen"   );
const Action_FileSave   = new Action( cast(int)EditorActions.FileSave  , "FileSave"  , "save" );
const Action_FileSaveAs = new Action( cast(int)EditorActions.FileSaveAs, "FileSaveAs", "save_again" );
const Action_FileClose  = new Action( cast(int)EditorActions.FileClose , "FileClose"  );

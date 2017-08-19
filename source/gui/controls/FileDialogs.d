/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.FileDialogs;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.filedlg;

class FileSaveDialog : FileDialog
{
    enum FileFlags = FileDialogFlag.Save |
        FileDialogFlag.ConfirmOverwrite |
        FileDialogFlag.EnableCreateDirectory;

    public:
        this ( UIString c, Window w )
        {
            super( c, w, null, FileFlags );
            _flags = DialogFlag.Popup;
        }
}

class FileOpenDialog : FileDialog
{
    enum FileFlags = FileDialogFlag.Open |
        FileDialogFlag.FileMustExist;
    public:
        this ( UIString c, Window w )
        {
            super( c, w, null, FileFlags );
            _flags = DialogFlag.Popup;
        }
}

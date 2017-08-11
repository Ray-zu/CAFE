/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.FragmentsExplorer;
import cafe.gui.Action;
import std.regex,
       std.string;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.filedlg,
       dlangui.widgets.metadata;

mixin( registerWidgets!FragmentsExplorer );

/+ 素材一覧のリスト +/
class FragmentsExplorer : TextWidget
{
    enum Style = "FRAGS_EXPLORER";
    private:
        this ( string id = "" )
        {
            super( id, "Not Implemented"d );
            styleId   = Style;
            alignment = Align.VCenter | Align.HCenter;
            minWidth  = 300;
        }
}

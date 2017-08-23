/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ErrorPanel;
import dlangui,
       dlangui.dialogs.dialog;

class ErrorPanel : Dialog
{
    enum DlgFlags = DialogFlag.Popup;

    enum Layout = q{
        VerticalLayout {
            layoutWidth:FILL_PARENT;
            TextWidget { text:"We are sorry but something went to wrong..."; fontSize:16 }
            EditBox { id:summary }
            TextWidget { text:"debug information" }
            EditBox { id:debug_info; minHeight:300 }
        }
    };

    private:
        Throwable error;

    public:
        this ( Throwable e, Window w )
        {
            super( UIString.fromRaw("An error occurred"), w, DlgFlags );
            error = e;
        }

        override void initialize ()
        {
            addChild( parseML(Layout) );
            childById("summary")
                .enabled(false).text = error.msg.to!dstring;
            childById("debug_info")
                .enabled(false).text = error.info.to!dstring;
            addChild( createButtonsPanel( [ACTION_ABORT,ACTION_IGNORE], 1, 1 ) );

            dialogResult = delegate ( Dialog d, const Action a )
            {
                if ( a.id == ACTION_ABORT.id )
                    window.close;
            };
        }
}

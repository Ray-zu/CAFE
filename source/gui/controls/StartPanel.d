/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.StartPanel;
import cafe.gui.controls.MainFrame;
import dlangui,
       dlangui.dialogs.dialog;

/+ プロジェクトが開いてない時に表示されるダイアログ +/
class StartPanel : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Layout  = q{
        VerticalLayout {
            HorizontalLayout {
                layoutWidth : FILL_PARENT;
                HSpacer {}
                TextWidget { id:header; fontSize:24 }
                HSpacer {}
            }
        }
    };

    public:
        this ( Window w = null )
        {
            super( UIString.fromRaw(""), w, DlgFlag );
            show;
        }

        override void initialize ()
        {
            addChild( parseML(Layout) );
            childById( "header" ).text = MainFrame.AppText;
        }
}

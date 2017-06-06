/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyEditBox;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.conv,
       std.format;
import dlangui,
       dlangui.dialogs.dialog;

/+ プロパティの値を編集するダイアログ +/
class PropertyEditBox : Dialog
{
    enum Caption = UIString.fromRaw("PropertyEdit");
    enum Message = "Please enter new value.";

    private:
        Property prop;
        FrameAt  frame_at;

    public:
        @property property () { return prop;     }
        @property frame    () { return frame_at; }

        this ( Property p, FrameAt f, Window parent, void delegate() handler )
        {
            prop = p;
            frame_at = f;

            super( Caption, parent, DialogFlag.Modal | (Platform.instance.uiDialogDisplayMode & DialogDisplayMode.inputBoxInPopup ? DialogFlag.Popup : 0));

            dialogResult = delegate ( Dialog d, const Action a )
            {
                try {
                    property.setString( frame, childById("input_value").text.to!string );
                } catch ( Exception e ) {
                    parent.showMessageBox( "Illegal Value"d, e.msg.to!dstring );
                } finally {
                    handler();
                }
            };
        }

        override void initialize ()
        {
            padding( Rect( 10, 10, 10, 10 ) );

            auto message = new MultilineTextWidget(
                    "message", UIString.fromRaw(Message) );
            message.padding( Rect( 10, 10, 10, 10 ) );

            EditWidgetBase editor = property.allowMultiline ?
                new EditBox( "input_value" ) : new EditLine( "input_value" );
            editor.text = property.getString( frame ).to!dstring;
            keyEvent = delegate ( Widget w, KeyEvent e ) {
                if ( e.flags == KeyFlag.Control && e.keyCode == KeyCode.RETURN ) {
                    try {
                        property.setString( frame, childById("input_value").text.to!string );
                        (cast(Dialog)w).close( ACTION_OK );
                    } catch ( Exception e ) {
                        childById("message").text =
                            "%s\nError : %s".format( Message, e.msg ).to!dstring;
                    }
                } return true;
            };

            addChild( message );
            addChild( editor );
        }

        override void show ()
        {
            super.show;
            childById( "input_value" ).setFocus;
        }
}

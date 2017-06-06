/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.PropertyEditBox;
import cafe.project.timeline.property.Property,
       cafe.project.ObjectPlacingInfo;
import std.conv;
import dlangui,
       dlangui.dialogs.dialog;

/+ プロパティの値を編集するダイアログ +/
class PropertyEditBox : Dialog
{
    enum Caption = UIString.fromRaw("PropertyEdit");
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
            EditWidgetBase editor;

            if ( property.allowMultiline ) {    // 複数行プロパティ
                editor = new EditBox( "input_value" );
                auto e = cast(EditBox)editor;
            } else {                            // 単数業プロパティ
                editor = new EditLine( "input_value" );
                keyEvent = delegate ( Widget w, KeyEvent e )
                {
                    if ( e.keyCode == KeyCode.RETURN )
                        (cast(Dialog)w).close( ACTION_OK );
                    return true;
                };
            }

            editor.text = property.getString( frame ).to!dstring;
            editor.contentChange = delegate( EditableContent w )
            {
                // TODO : Value Check
            };

            addChild( editor );
        }

        override void show ()
        {
            super.show;
            childById( "input_value" ).setFocus;
        }
}

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
                property.setString( frame, childById("input_value").text.to!string );
                handler();
            };
        }

        override void initialize ()
        {
            auto editor = new EditBox( "input_value" );
            editor.text = property.getString( frame ).to!dstring;

            editor.contentChange = delegate( EditableContent w )
            {
                // TODO : Value Check
            };

            addChild( editor );
        }
}

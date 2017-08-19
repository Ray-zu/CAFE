/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.AppInfoPanel;
import cafe.config;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.widgets.metadata;

class AppInfoPanel : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Width = 400;
    enum Height = 300;

    enum Layout = q{
        VerticalLayout {
            ImageWidget { drawableId:cafe_logo; alignment:HCenter }
            TextWidget { id:app_text; fontSize:16; alignment:HCenter }
            Button { id:license; alignment:HCenter; styleId:TEXT }
            TextWidget { text:"Presented by" }
            EditBox { id:presented; layoutWidth:FILL_PARENT; fontSize:12; minWidth:400; minHeight:300 }
            Button { id:homepage; alignment:HCenter; styleId:TEXT }
        }
    };

    enum PresentedBy = 
"<Interface>
    aoitofu
<Renderer>
    SEED264
<GUI>
    aoitofu
<Design>
    Aodaruma
<Object / Effect>
    aoitofu
    SEED264
    Aodaruma";

    enum SpecialThanks = "";

    public:
        this ( Window w = null )
        {
            super( UIString.fromRaw( "Version" ), w, DlgFlag );
            addChild( parseML( Layout ) );
            addChild( createButtonsPanel( [ACTION_CLOSE], 0, 0 ) );

            childById( "app_text" ).text = AppText;
            childById( "presented" ).enabled(false).text = PresentedBy;
            childById( "license" ).text(License).click = delegate ( Widget w )
            {
                Platform.instance.openURL( LicenseURL );
                return true;
            };
            childById( "homepage" ).text(AppURL).click = delegate ( Widget w )
            {
                Platform.instance.openURL( AppURL );
                return true;
            };
        }
}

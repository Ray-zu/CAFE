/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.MainFrame;
import cafe.gui.Action;
import std.conv,
       std.format;
import dlangui;

class MainFrame : AppFrame
{
    enum AppName = "CAFEditor";
    enum AppVer  = "0.99 beta";
    enum AppText = "%s %s".format( AppName, AppVer );

    enum Layout = q{
        VerticalLayout {
            HorizontalLayout {
                BMPViewer { }
            }
            TimelineWidget { id:timeline }
        }
    };

    private:
        MenuItem top_menu;

    protected:
        override void initialize ()
        {
            _appName = AppText;
            super.initialize();
        }

        override Widget createBody ()
        {
            return parseML( Layout );
        }

        override MainMenu createMainMenu ()
        {
            top_menu = new MenuItem;

            auto menu = new MenuItem( new Action( 1, "TopMenu_File" ) );
            with ( menu ) {
                add( Action_ProjectNew    );
                add( Action_ProjectOpen   );
                add( Action_ProjectSave   );
                add( Action_ProjectSaveAs );
                add( Action_ProjectClose  );
            }
            top_menu.add( menu );

            with ( menu = new MenuItem( new Action( 1, "TopMenu_Play" ) ) ) {
                add( Action_Play  );
                add( Action_Pause );
                add( Action_Stop  );

                add( Action_MoveBehind );
                add( Action_MoveAHead  );

                add( Action_ShiftBehind );
                add( Action_ShiftAHead  );
            }
            top_menu.add( menu );

            return new MainMenu( top_menu );
        }

        override ToolBarHost createToolbars ()
        {
            auto host = new ToolBarHost;
            auto bar  = host.getOrAddToolbar( "File" );
            with ( bar ) {
                addButtons( Action_ProjectSave   );
                addButtons( Action_ProjectSaveAs );
            }
            with ( bar = host.getOrAddToolbar( "Play" ) ) {
                addButtons( Action_Play  );
                addButtons( Action_Pause );
                addButtons( Action_Stop  );

                addButtons( Action_MoveBehind );
                addButtons( Action_MoveAHead  );

                addButtons( Action_ShiftBehind );
                addButtons( Action_ShiftAHead  );
            }
            return host;
        }

    public:
        this ()
        {
            super();
            statusLine.setStatusText( i18n.get( "Status_Boot" ) );
        }
}

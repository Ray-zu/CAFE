/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.MainFrame;
import std.conv,
       std.format;
import dlangui;

class MainFrame : AppFrame
{
    enum AppName = "CAFEditor";
    enum AppVer  = "0.99 beta";
    enum AppText = "%s %s".format( AppName, AppVer );

    private:
        MenuItem top_menu;

    protected:
        override void initialize ()
        {
            _appName = AppText;
            super.initialize();
        }

        override MainMenu createMainMenu ()
        {
            top_menu = new MenuItem;
            auto file = new MenuItem( new Action( 1, "MENU_FILE" ) );
            with ( file ) {
                add( new Action( 0 ) );
            }
            top_menu.add( file );
            return new MainMenu( top_menu );
        }

    public:
        this ()
        {
            super();
        }
}

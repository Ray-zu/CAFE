/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.app;
import dlangui;

mixin APP_ENTRY_POINT;

extern(C) int UIAppMain(string[] args)
{
    Platform.instance.uiLanguage="en";
    Platform.instance.uiTheme="theme_default";

    auto window = Platform.instance.createWindow("CAFEdit",null);
    window.mainWidget = new FrameLayout;
    window.show;
    return Platform.instance.enterMessageLoop();
}

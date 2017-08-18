/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.config;
import dlangui.core.settings;

class Config : SettingsFile
{
    static __gshared Config instance = new Config;

    public:
        this ()
        {
            super();
        }
}
alias CafeConf = Config.instance;

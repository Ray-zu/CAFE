/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.CafeConfDialog;
import cafe.config;
import std.algorithm,
       std.format,
       std.range;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.settingsdialog;

private @property uistr ( string v, string c = "" )
{
    return UIString.fromId( "Setting_%s/%s".format(c,v) );
}

class CafeConfDialog : SettingsDialog
{
    private:
        auto createPage ()
        {
            auto r = new SettingsPage( "", "".uistr );
            with ( r.addChild( "layout", "layout".uistr ) ) {
                auto cur = "layout";
                with ( addChild( cur~"/main", "main".uistr(cur) ) ) {
                    auto cur2 = cur~"/main";
                    [
                        new NumberEditItem( cur2~"/PreviewHeight", "PreviewHeight".uistr(cur2), 100, 1000, 350 ),
                        new NumberEditItem( cur2~"/ConfigWidth"  , "ConfigWidth"  .uistr(cur2), 100, 1000, 400 )
                    ].each!( x => addItem(x) );
                }
                with ( addChild( cur~"/chooser_dialog", "chooser_dialog".uistr(cur) ) ) {
                    auto cur2 = cur~"/chooser_dialog";
                    [
                        new NumberEditItem( cur2~"/Width"     , "Width"     .uistr(cur2), 100, 1000, 400 ),
                        new NumberEditItem( cur2~"/Height"    , "Height"    .uistr(cur2), 100, 1000, 600 ),
                        new NumberEditItem( cur2~"/ItemWidth" , "ItemWidth" .uistr(cur2), 100,  500, 100 ),
                        new NumberEditItem( cur2~"/ItemHeight", "ItemHeight".uistr(cur2), 100,  500, 100 )
                    ].each!( x => addItem(x) );
                }
                with ( addChild( cur~"/timeline", "timeline".uistr(cur) ) ) {
                    auto cur2 = cur~"/timeline";
                    [
                        new NumberEditItem( cur2~"/MinimumGridInterval", "MinimumGridInterval".uistr(cur2), 5, 50, 10 ),
                        new NumberEditItem( cur2~"/MiddlePointSize"    , "MiddlePointSize"    .uistr(cur2), 5, 50, 12 )
                    ].each!( x => addItem(x) );
                }
            }
            with ( r.addChild( "behaviour", "behaviour".uistr ) ) {
                auto cur = "behaviour";
                with ( addChild( cur~"/timeline", "timeline".uistr(cur) ) ) {
                    auto cur2 = cur~"/timeline";
                    [
                        new FloatEditItem ( cur2~"/WheelMagnification"   , "WheelMagnification"   .uistr(cur2), 0,    5,  2.0 ),
                        new FloatEditItem ( cur2~"/VScrollMagnification" , "VScrollMagnification" .uistr(cur2), 0, 10.0, 10.0 ),
                        new FloatEditItem ( cur2~"/FrameRemnant"         , "FrameRemnant"         .uistr(cur2), 0,  1.0,  0.3 ),
                        new NumberEditItem( cur2~"/CorrectableDistancePx", "CorrectableDistancePx".uistr(cur2), 0,  100,   10 )
                    ].each!( x => addItem(x) );
                }
            }
            with ( r.addChild( "text", "text".uistr ) ) {
                auto cur = "text";
                with ( addChild( cur~"/timeline", "timeline".uistr(cur) ) ) {
                    auto cur2 = cur~"/timeline";
                    [
                        new StringEditItem( cur2~"/LayerTitle", "LayerTitle".uistr(cur2), "Layer %d" )
                    ].each!( x => addItem(x) );
                }
            }
            return r;
        }

    public:
        this ( Window w )
        {
            super( UIString.fromRaw("Configure"),
                    w, CafeConf.setting, createPage );
            _flags = DialogFlag.Popup;
        }
}

/+ dlangui.dialogs.settingsdialog.NumberEditItem をfloat用に変更 +/
class FloatEditItem : SettingsItem {
    protected float _minValue;
    protected float _maxValue;
    protected float _defaultValue;
    this(string id, UIString label, float minValue = 0, float maxValue = 100, float defaultValue = 0) {
        super(id, label);
        _minValue = minValue;
        _maxValue = maxValue;
        _defaultValue = defaultValue;
    }
    /// create setting widget
    override Widget[] createWidgets(Setting settings) {
        TextWidget lbl = new TextWidget(_id ~ "-label", _label);
        EditLine ed = new EditLine(_id ~ "-edit", _label);
        ed.minWidth = 100;
        Setting setting = settings.settingByPath(_id, SettingType.FLOAT);
        float n = setting.floatingDef(_defaultValue);
        if (n < _minValue) n = _minValue;
        if (n > _maxValue) n = _maxValue;
        setting.floating = n;
        ed.text = toUTF32(to!string(n));
        ed.contentChange = delegate(EditableContent content) {
            float v;
            auto error = false;
            try {
                v = content.text.to!float;
            } catch ( Exception e ) {
                error = true;
            }
            if (v >= _minValue && v <= _maxValue && !error) {
                setting.floating = v;
                ed.textColor = 0xFFFFFF;
            } else {
                ed.textColor = 0xFF0000;
            }
        };
        return [lbl, ed];
    }
}

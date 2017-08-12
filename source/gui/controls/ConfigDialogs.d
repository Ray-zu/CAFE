/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.ConfigDialogs;
import cafe.app,
       cafe.gui.Action,
       cafe.project.Project,
       cafe.project.Component,
       cafe.project.ComponentList;
import std.format,
       std.regex;
import dlangui,
       dlangui.dialogs.dialog,
       dlangui.dialogs.settingsdialog;

/+ プロジェクト設定 +/
class ProjectConfigDialog : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Caption = "Project Configure";

    enum Layout = q{
        TableLayout {
            colCount:2;
            TextWidget { text:"author" }
            EditLine { id:author; minWidth:200 }
            TextWidget { text:"copyright" }
            EditLine { id:copyright; minWidth:200 }
            TextWidget { text:"samplingRate" }
            EditLine { id:sampling_rate }
            TextWidget { text:"FPS" }
            EditLine { id:fps }
        }
    };

    private:
        Project pro;

    public:
        @property project () { return pro; }

        this ( bool create, Window w = null )
        {
            super( UIString.fromRaw(Caption), w, DlgFlag );
            addChild( parseML( Layout ) );
            addChild( new TextWidget( "error" ) )
                .textColor( 0xff0000 ).alignment( Align.HCenter );
            addChild( createButtonsPanel(
                        [ACTION_CANCEL,ACTION_OK], 0, false ) );
            pro = create ? null : Cafe.instance.curProject;
        }

        override void initialize ()
        {
            if ( !project ) pro = new Project;
            childById("author"       ).text = project.author      .to!dstring;
            childById("copyright"    ).text = project.copyright   .to!dstring;
            childById("sampling_rate").text = project.samplingRate.to!dstring;
            childById("fps"          ).text = project.fps         .to!dstring;
        }

        override bool handleAction ( const Action a )
        {
            bool matchInteger ( string v )
            {
                enum IntegerRegex = `^\d+$`;
                return cast(bool)v.match( IntegerRegex );
            }

            if ( a.id == ACTION_OK.id ) {
                project.author       = childById("author"      ).text.to!string;
                project.copyright    = childById("copyright"   ).text.to!string;

                auto rate = childById("sampling_rate").text.to!string;
                auto fps  = childById("fps"          ).text.to!string;
                if ( matchInteger(rate) && matchInteger(fps) ) {
                    project.samplingRate = rate.to!uint;
                    project.fps          = fps .to!uint;
                } else {
                    childById("error").text = "Invalid Integer"d;
                    return false;
                }
                if ( Cafe.instance.curProject !is project )
                    Cafe.instance.curProject = project;
            }
            return super.handleAction( a );
        }
}

/+ コンポーネント設定 +/
class ComponentConfigDialog : Dialog
{
    enum DlgFlag = DialogFlag.Popup;
    enum Caption = "Component Configure";

    enum Layout = q{
        TableLayout {
            colCount:2;
            TextWidget { text:"name" }
            EditLine { id:name; minWidth:200 }
            TextWidget { text:"author" }
            EditLine { id:author }
            TextWidget { text:"width" }
            EditLine { id:width }
            TextWidget { text:"height" }
            EditLine { id:height }
        }
    };

    private:
        Project pro;
        string comp_id;
        Component component;

    public:
        @property project () { return pro; }

        this ( Project p, string id, Window w = null )
        {
            super( UIString.fromRaw(Caption), w, DlgFlag );
            addChild( parseML( Layout ) );
            addChild( new TextWidget( "error" ) )
                .textColor( 0xff0000 ).alignment( Align.HCenter );
            addChild( createButtonsPanel(
                        [ACTION_CANCEL,ACTION_OK], 0, false ) );
            pro       = p;
            comp_id   = id;
            component = (id == "") ? null : project.componentList[id];
        }

        override void initialize ()
        {
            if ( !component ) component = new Component;
            childById("name"  ).text = comp_id         .to!dstring;
            childById("author").text = component.author.to!dstring;
            childById("width" ).text = component.width .to!dstring;
            childById("height").text = component.height.to!dstring;

            childById("name").enabled = comp_id != ComponentList.RootId;
        }

        override bool handleAction ( const Action a )
        {
            bool matchInteger ( string v )
            {
                enum IntegerRegex = `^\d+$`;
                return cast(bool)v.match( IntegerRegex );
            }

            if ( a.id == ACTION_OK.id ) {
                auto w = childById("width" ).text.to!string;
                auto h = childById("height").text.to!string;
                auto n = childById("name").text.to!string;

                if ( !matchInteger(w) || !matchInteger(h) ) {
                    childById("error").text = "Invalid Integer"d;
                    return false;
                }
                if ( n == "" ) {
                    childById("error").text = "name is required.";
                    return false;
                }
                if ( n !in project.componentList.components ) {
                    if ( comp_id == "" )
                        project.componentList[n] = component;
                    else project.componentList.rename( comp_id, n );

                } else if ( comp_id != n ) {
                    childById("error").text =
                        "%s is already exists.".format(n).to!dstring;
                    return false;
                }
                component.resize( w.to!uint, h.to!uint );
                component.author = childById("author").text.to!string;

                window.mainWidget.handleAction( Action_CompTreeRefresh );
            }
            return super.handleAction( a );
        }
}

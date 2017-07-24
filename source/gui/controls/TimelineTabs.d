/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.TimelineTabs;
import cafe.project.Project,
       cafe.project.Component,
       cafe.gui.controls.timeline.TimelineWidget;
import std.algorithm;
import dlangui,
       dlangui.widgets.metadata;

mixin( registerWidgets!TimelineTabs );

/+ 複数のタイムラインを管理 +/
class TimelineTabs : TabWidget
{
    private:
        Project pro = null;

        void addTab ( string name, Component com, bool closeable = true )
        {
            auto tlw = new TimelineWidget;
            tlw.editor.timeline = com.timeline;
            super.addTab( tlw, name.to!dstring, null, closeable );
        }

    public:
        @property project () { return pro; }
        @property project ( Project p )
        {
            pro = p;
            if ( project )
                addTab( "root", project.componentList.root, false );
            else
                clearAllTabs;
        }

        this ( string id = "" )
        {
            super( id );
        }

        void clearAllTabs ()
        {
            TabItem t;
            while ( (t = tab(0)) !is null )
                removeTab( t.id );
        }
}

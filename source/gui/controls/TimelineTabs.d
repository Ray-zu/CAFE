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
    enum EmptyLayout = q{
        FrameLayout {
            id:empty;
            VSpacer {}
        }
    };

    private:
        Project pro = null;
        TimelineWidget[] timelines;

        void addTab ( string name, Component com, bool closeable = true )
        {
            timelines ~= new TimelineWidget( name, pro, com ? com.timeline : null );
            super.addTab( timelines[$-1], name.to!dstring, null, closeable );
            selectTab = name;
        }

    protected:
        override void onTabChanged ( string n, string p )
        {
            if ( !project ) return;
            project.componentList.selecting =
                n in project.componentList.components ?
                project.componentList[n] : null;
            updateWidgets;
        }

        override void onTabClose ( string n )
        {
            if ( !project ) return;
            removeTab( n );
        }

    public:
        @property project () { return pro; }
        @property project ( Project p )
        {
            pro = p;
            clearAllTabs;
            if ( project )
                addTab( "ROOT", project.componentList.root, false );
            else
                addTab( "no project", null, false );
        }

        this ( string id = "" )
        {
            super( id );
        }

        void addTab ( string cid )
        {
            if ( !tab( cid ) )
                addTab( cid, project.componentList[cid] );
            else
                selectTab( cid );
        }

        void clearAllTabs ()
        {
            TabItem t;
            while ( (t = tab(0)) !is null )
                removeTab( t.id );
            timelines = null;
        }

        void updateWidgets ()
        {
            auto t = (cast(TimelineWidget)selectedTabBody);
            if ( t ) t.updateCache;
        }
}

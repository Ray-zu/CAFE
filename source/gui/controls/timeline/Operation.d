/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.gui.controls.timeline.Operation;
import cafe.project.Project,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.Timeline,
       cafe.project.timeline.PlaceableObject,
       cafe.project.timeline.property.Property,
       cafe.gui.controls.timeline.Cache,
       cafe.gui.controls.timeline.Line,
       cafe.gui.controls.timeline.ObjectEditor,
       cafe.gui.controls.timeline.PropertyEditor;
import std.algorithm;
import dlangui;

/+ タイムラインイベントのデータ受け渡しクラス +/
class Operation 
{
    enum State {
        None,

        Clicking,
        Dragging,

        ResizingStart,
        ResizingEnd,

        Processed
    }

    private:
        Cache cache;
        State state;

        void moveObj ( uint f, uint l )
        {
            auto line = cache.lines[l];
            auto obj  = operatingObject;
            auto rf   = f.to!int - frameOffset;
            rf = max( 0, min( rf, cache.timeline.length.value-1 ) );

            if ( line.layerIndex == -1 )
                moveObj( f, l+1 );
            else {
                obj.place.frame.move( new FrameAt( rf ) );
                obj.place.layer.value = line.layerIndex;
                cache.updateLinesCache;
            }
        }

        auto moveProp ( uint f, uint l )
        {
            auto prop = operatingProperty;
            prop.moveMP( f, middlePointIndex );
        }

    public:
        PlaceableObject operatingObject   = null;
        Property        operatingProperty = null;

        int  frameOffset      = 0;
        uint middlePointIndex = 0;

        /+ 編集操作中かどうか +/
        @property isProcessing ()
        {
            return state != State.None && state != State.Processed;
        }
        /+ 既にイベント処理が終わっているかどうか +/
        @property isProcessed ()
        {
            return state == State.Processed;
        }
        /+ イベントがハンドルされたかどうか +/
        @property isHandled ()
        {
            return state != State.None;
        }

        this ( Cache c )
        {
            cache = c;
            state = State.None;
        }

        auto clear ()
        {
            state             = State.None;
            operatingObject   = null;
            operatingProperty = null;
            frameOffset = 0;
        }

        auto processed ()
        {
            if ( !isHandled ) state = State.Processed;
        }

        auto clicking ( State s = State.Clicking )
        {
            if ( !isHandled ) state = s;
        }

        auto move ( uint f, uint l )
        {
            switch ( state ) with ( State ) {
                case Clicking:
                    state = Dragging;
                    goto case;
                case Dragging:
                    if ( operatingObject   ) moveObj ( f, l );
                    if ( operatingProperty ) moveProp( f, l );
                    break;
                case ResizingStart:
                    if ( operatingObject )
                        operatingObject.resizeStart( new FrameAt(f) );
                    break;
                case ResizingEnd:
                    if ( operatingObject )
                        operatingObject.resizeEnd( new FrameAt(f) );
                    break;
                default:
            }
        }

        auto release ( uint f )
        {
            if ( state == State.Clicking ) {
                if ( operatingObject ) {
                    // オブジェクトを左クリック
                    cache.timeline.selecting = cache.timeline
                        .selecting is operatingObject ? null : operatingObject;
                    cache.updateLinesCache;

                } else if ( operatingProperty ) {
                    // プロパティを左クリック
                    operatingProperty.graphOpened = !operatingProperty.graphOpened;
                    cache.updateLinesCache;
                }
            }
            clear;
        }
}

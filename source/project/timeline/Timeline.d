/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.Timeline;
import cafe.json,
       cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject;
import std.algorithm,
       std.array,
       std.conv,
       std.math,
       std.json;

debug = 0;

/+ タイムラインデータ +/
class Timeline
{
    private:
        PlaceableObject[] objs;
        FrameLength frame_len;

        /+ fに最も近く、oオブジェクトの長さ分のスペースがある部分の +
         + 最初のフレーム数を返す                                   +
         + rfにはカーソルのフレーム位置を指定する。                 +/
        FrameAt reserveSpace ( PlaceableObject o, FrameAt f, LayerId i, int rf )
        {
            auto fv   = f.value;
            auto lv   = o.place.frame.length.value;
            auto objs = this[i].sort
                !( (a,b) => a.place.frame.start.value < b.place.frame.start.value )
                .remove!( x => x is o ).array;

            auto coll = this[new FrameAt(fv),new FrameLength(lv),i]
                .remove!( x => x is o );
            if ( coll.length == 0 && fv+lv <= length.value ) {
                return f;
            }

            auto prev_frame = 0;
            auto result     = 0;
            auto rscore     = uint.max;

            auto score ( uint st, uint ed )
            {
                auto st_score = abs( st.to!int - rf );
                auto ed_score = abs( ed.to!int - rf );
                return min( st_score, ed_score );
            }
            auto scoreCheck ( uint st )
            {
                if ( st+lv > length.value ) return;

                auto cscore = score( st, st+lv );
                if ( cscore < rscore ) {
                    result = st;
                    rscore = cscore;
                }
            }
            foreach ( obj; objs ) {
                auto st = obj.place.frame.start.value;
                if ( st.to!int - prev_frame.to!int >= lv.to!int )
                    scoreCheck( prev_frame );
                if ( st.to!int - lv.to!int >= prev_frame.to!int )
                    scoreCheck( st - lv );
                prev_frame = obj.place.frame.end.value;
            }
            scoreCheck( prev_frame );
            if ( length.value - prev_frame >= lv )
                scoreCheck( length.value - lv );

            if ( rscore == uint.max || result+lv > length.value )
                throw new Exception( "No Space To Move" );
            else return new FrameAt( result );
        }

        /+ 編集情報 +/
        FrameAt current_frame;
    public:
        PlaceableObject selecting = null;
        uint  leftFrame  = 0;
        uint  rightFrame = 100;
        float topLineIndex = 0;
        @property frame () { return current_frame; }

        @property objects () { return objs;      }
        @property length  () { return frame_len; }

        this ( Timeline src )
        {
            src.objects.each!( x => objs ~= x.copy );
            frame_len = new FrameLength( src.length );
            current_frame = new FrameAt( src.frame );
        }

        this ( FrameLength f = new FrameLength(1) )
        {
            objs = [];
            frame_len = f;
            current_frame = new FrameAt(0);
        }

        this ( JSONValue j )
        {
            frame_len = new FrameLength( j["length"].getUInteger );
            j["objects"].array.each!
                ( x => objs ~= PlaceableObject.create( x, frame_len ) );
            current_frame = new FrameAt( j["frame"].getUInteger );
            leftFrame  = j["leftFrame" ].getUInteger;
            rightFrame = j["rightFrame"].getUInteger;
            topLineIndex = j["topLineIndex"].getFloating;
        }

        /+ オブジェクトの配置されている最大のレイヤ数を返す +/
        @property layerLength ()
        {
            auto r = objects.length ?
                objects.maxElement!"a.place.layer.value".place.layer.value+1:
                0;
            return r;
        }

        /+ オブジェクトを移動 +/
        void move ( PlaceableObject obj, FrameAt f, LayerId i, int rf )
        {
            FrameAt vf;
            try {
              vf = reserveSpace( obj, f, i, rf );
            } catch ( Exception e ) {
                return;
            }
            obj.place.frame.move( vf );
            obj.place.layer.value = i.value;
        }

        /+ objを削除 +/
        void remove ( PlaceableObject obj )
        {
            objs = objects.remove!( x => x is obj );
        }

        /+ this += obj : オブジェクトを追加 +/
        auto opAddAssign ( PlaceableObject obj )
        {
            objs ~= obj;
            if ( obj.place.frame.end.value >= length.value )
                length.value = obj.place.frame.end.value;
            return this;
        }

        /+ this[f] : フレームfの処理対象のオブジェクト配列を返す +/
        auto opIndex ( FrameAt f )
        {
            return objects.filter!( x => x.place.frame.isInRange(f) ).array;
        }

        /+ this[l] : レイヤlのオブジェクト配列を返す +/
        auto opIndex ( LayerId l )
        {
            return objects.filter!( x => x.place.layer.value == l.value ).array;
        }

        /+ this[f] : フレーム期間fのオブジェクト配列を返す +/
        auto opIndex ( FramePeriod f )
        {
            return objects.filter!( x => x.place.frame.isWhileRange(f) ).array;
        }

        /+ this[f1,len] : f1からlen期間のオブジェクト配列を返す +/
        auto opIndex ( FrameAt f1, FrameLength len )
        {
            return this[ new FramePeriod( length, f1, len ) ];
        }

        /+ this[f,l] : フレームf,レイヤlにあるオブジェクトを返す +
         + 無い場合はNULL                                        +/
        auto opIndex ( FrameAt f, LayerId l )
        {
            auto objs = this[f];
            auto i = objs.countUntil!( x => x.place.layer.value == l.value );
            return i >= 0 ? objs[i] : null;
        }

        /+ this[f1,len,l] : f1からlen期間中からレイヤlに配置されている +
           オブジェクトの配列を返す                                    +
         + 結果は開始フレーム数が早い順に並べられます。                +/
        auto opIndex ( FrameAt f1, FrameLength len, LayerId l )
        {
            return this[f1,len].filter!( x => x.place.layer.value == l.value ).array
                .sort!( (a,b) => a.place.frame.start.value < b.place.frame.start.value ).array;
        }

        /+ JSONで出力 +/
        @property json ()
        {
            JSONValue j;
            j["length"] = JSONValue( length.value );

            JSONValue[] objs;
            objects.each!( x => objs ~= x.json );
            j["objects"] = JSONValue( objs );

            j["frame"] = JSONValue( frame.value );
            j["leftFrame" ] = JSONValue( leftFrame  );
            j["rightFrame"] = JSONValue( rightFrame );
            j["topLineIndex"] = JSONValue( topLineIndex );
            return j;
        }
}

/+ ------------------------------------------------------------ +
 + Author : aoitofu <aoitofu@dr.com>                            +
 + This is part of CAFE ( https://github.com/aoitofu/CAFE ).    +
 + ------------------------------------------------------------ +
 + Please see /LICENSE.                                         +
 + ------------------------------------------------------------ +/
module cafe.project.timeline.Timeline;
import cafe.project.ObjectPlacingInfo,
       cafe.project.timeline.PlaceableObject;
import std.algorithm,
       std.array,
       std.conv,
       std.json;

debug = 0;

/+ タイムラインデータ +/
class Timeline
{
    private:
        PlaceableObject[] objs;
        FrameLength frame_len;

    public:
        @property objects () { return objs;      }
        @property length  () { return frame_len; }

        this ( Timeline src )
        {
            src.objects.each!( x => objs ~= x.copy );
            frame_len = new FrameLength( src.length );
        }

        this ( FrameLength f = new FrameLength(1) )
        {
            objs = [];
            frame_len = f;
        }

        this ( JSONValue j )
        {
            frame_len = new FrameLength( j["length"].uinteger.to!uint );
            j["objects"].array.each!
                ( x => objs ~= PlaceableObject.create( x, frame_len ) );
        }

        /+ オブジェクトの配置されている最大のレイヤ数を返す +/
        @property layerLength ()
        {
            auto r = objects.length ?
                objects.maxElement!"a.place.layer.value".place.layer.value:
                0;
            return new LayerId( r );
        }

        /+ objを削除 +/
        void remove ( PlaceableObject obj )
        {
            objects.remove!( x => x is obj );
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
            auto i = this[f].find!( x => x.place.layer.value == l.value ).array;
            if ( i.length != 1 ) return null;
            return i[0];
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

            return j;
        }

        debug (1) unittest {
            import cafe.project.timeline.custom.NullObject;
            auto hoge = new Timeline( new FrameLength( 10 ) );

            auto opi = new ObjectPlacingInfo( new LayerId(0),
                   new FramePeriod( hoge.length, new FrameAt(0), new FrameLength(5) ) );
            auto obj1 = new NullObject( opi );
            hoge += obj1;

            assert( hoge[new FrameAt(0)].length == 1 );
            assert( hoge[new FrameAt(0),new FrameLength(1),new LayerId(0)].length == 1 );
            assert( hoge[new FrameAt(0),new FrameLength(1),new LayerId(1)].length == 0 );

            auto hoge2 = new Timeline( hoge.json );
            assert( hoge.objects.length == hoge2.objects.length );
        }
}

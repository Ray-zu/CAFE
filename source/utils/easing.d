/+ Copyright (C) 2017 aoitofu / Aodaruma / SEED264
   Author : aoitofu <aoitofu@dr.com>
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>
+/

module cafe.utils.easing;
import std.math;
import cafe.types;

debug = 1;

/+ イージングの種類を表します。
   イージングの詳細については下記URLを参考にしてください。
   http://gizma.com/easing/
+/
enum EasingType
{
    Linear,
    QuadraticEasingIn,
    QuadraticEasingOut,
    QuadraticEasingIO,
    CubicEasingIn,
    CubicEasingOut,
    CubicEasingIO,
    QuarticEasingIn,
    QuarticEasingOut,
    QuarticEasingIO,
    QuinticEasingIn,
    QuinticEasingOut,
    QuinticEasingIO,
    SinusoidalEasingIn,
    SinusoidalEasingOut,
    SinusoidalEasingIO,
    ExponentialEasingIn,
    ExponentialEasingOut,
    ExponentialEasingIO,
    CircularEasingIn,
    CircularEasingOut,
    CircularEasingIO
}


/+ イージング計算中の例外 +/
class CalculateEasingFault : Error
{
    public this ( string mes, string file = __FILE__, uint line = __LINE__ )
    {
        super( mes, file, line );
    }
}


/+ 名前長いわ! +/
private alias error = CalculateEasingFault;


/+ フレーム数、開始値、終了値からイージングされた中間値を求めます。
   type : イージングの種類
   cur  : 現在のフレーム数
   dur  : 総フレーム数
   st   : 開始値
   add  : 加算値 ( st + addが最終的な結果になる )

   式は http://gizma.com/easing/ を参考にしました。
+/
float calcEasing ( EasingType type, Frame cur, FrameLen dur, float st, float add )
{
    enum InvalidFrameIndex = "frame index is invalid";

    if ( cur >= dur || cur < 0 ) throw new error( InvalidFrameIndex );
    float ratio = (cur*1.0) / (dur*1.0);

    switch ( type ) {
        case EasingType.Linear:
            return add * (cur*1.0) / (dur*1.0) + st;

        case EasingType.QuadraticEasingIn:
            return add*ratio.pow(2) + st;

        case EasingType.QuadraticEasingOut:
            return -add*ratio*(ratio-2) + st;

        case EasingType.QuadraticEasingIO:
            if ( ratio < 1 ) return add/2*ratio.pow(2) + st;
            ratio--;
            return -add/2 * (ratio*(ratio-2) - 1) + st;

        case EasingType.CubicEasingIn:
            return add*ratio.pow(3) + st;

        case EasingType.CubicEasingOut:
            ratio--;
            return add*(ratio.pow(3) + 1) + st;

        case EasingType.CubicEasingIO:
            if ( ratio < 1 ) return add/2*ratio.pow(3) + st;
            ratio -= 2;
            return add/2*(ratio.pow(3) + 2) + st;

        case EasingType.QuarticEasingIn:
            return add*ratio.pow(4) + st;

        case EasingType.QuarticEasingOut:
            ratio--;
            return -add * (ratio.pow(4) - 1) + st;

        case EasingType.QuarticEasingIO:
            if ( ratio < 1 ) return add/2*ratio.pow(4) + st;
            ratio -= 2;
            return -add/2 * (ratio.pow(4) - 2) + st;

        case EasingType.QuinticEasingIn:
            return add*ratio.pow(5);

        case EasingType.QuinticEasingOut:
            ratio--;
            return add * (ratio.pow(5) + 1) + st;

        case EasingType.QuinticEasingIO:
            ratio /= 2;
            if ( ratio < 1 ) return add/2*ratio.pow(5) + st;
            ratio -= 2;
            return add/2 * (ratio.pow(5) + 2) + st;

            /+ TODO +/
        default: throw new Exception( "Not Implemented" );
    }
}


/+ イージング関数のテスト +/
debug ( 1 ) unittest {
    import std.stdio;
    assert( calcEasing( EasingType.Linear           , 50, 100, 50, 50 ) == 75 );
    assert( calcEasing( EasingType.QuadraticEasingIn, 50, 100, 50, 50 ) == 62.5 );
}

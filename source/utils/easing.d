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

/+ イージングの種類を表します。
   イージングの詳細については下記URLを参考にしてください。
   http://gizma.com/easing/
+/
enum EasingType
{
    Liner,
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

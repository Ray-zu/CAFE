/* ------------------------------------------------------------ *
 * Author : aoitofu <aoitofu@dr.com>                            *
 * This is part of CAFE ( https://github.com/aoitofu/CAFE ).    *
 * ------------------------------------------------------------ *
 * Please see /LICENSE.                                         *
 * ------------------------------------------------------------ */
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <stdio.h>
#include "gui.h"

/* 単体テスト用 (リリース時にはコメントアウトします) */
int main ( int argc, char ** argv )
{
    GUI_LoadInfo li = {argc, argv, (char*)"CAFE C++ GUI TEST", (char*)"1.00"};
    return gui_load( &li );
}

/* 名前空間の確認用 */
void hello_gui_cpp ()
{
    printf( "Hello gui on C++ !\n" );
}

/* ウィンドウをロード */
int gui_load ( GUI_LoadInfo *li )
{
    QApplication app( li->argc, li->argv );
    QLabel *label = new QLabel( li->app );
    label->show();
    return app.exec();
}

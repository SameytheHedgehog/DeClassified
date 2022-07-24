/*********************************
*   Filename: include-fade.m     *
*   Version:  1.1                *
*   Created:  2017-09-14         *
*   Updated:  2020-02-18         *
*   Author:   PeterK.            *
*   E-Mail:   peter_ka@gmx.net   *
*********************************/

#ifndef included
#error This script "include-fade.m" can only be compiled as #include
#endif

Function fade(GuiObject item,Int alpha,Int speed);

fade(GuiObject item,Int alpha,Int speed)
{
	item.setTargetA(alpha);
	item.setTargetSpeed(speed);
	item.gotoTarget();
}
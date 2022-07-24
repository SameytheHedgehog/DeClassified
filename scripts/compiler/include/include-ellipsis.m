/************************************
*   Filename: include-ellipsis.m    *
*   Version:  1.2                   *
*   Created:  2019-10-16            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "include-ellipsis.m" can only be compiled as #include
#endif

Global String ellipsis;

Function add_ellipsis(Text new_t,String new_s,Int length);

// Calculates length of a string in pixels - do not use System.strleft() - Verdana is not monospaced
add_ellipsis(Text new_t,String new_s,Int length)
{
	Int width=1;
	Int j=1;
	
	while (width<length)
	{
		new_t.setText(System.strleft(new_s,j));
		width=new_t.getTextWidth();
		j++;
	}
	ellipsis=System.strleft(new_s,j-1)+" ...";
}
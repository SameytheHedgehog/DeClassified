/***************************************
*   Filename: include-display-info.m   *
*   Version:  1.5                      *
*   Created:  2016-09-01               *
*   Updated   2020-02-18               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "include-display-info.m" can only be compiled as #include
#endif

Function displayInfo(String note,String message);

// Do not delete the if-query for Main Player in here
displayInfo(String note,String message)
{
	if (System.getContainer("main")!=NULL) System.getContainer("main").getLayout("normal").sendAction(note,message,0,0,0,0);
	if (System.getContainer("media.library")!=NULL) System.getContainer("media.library").getLayout("normal").sendAction(note,message,0,0,0,0);
}
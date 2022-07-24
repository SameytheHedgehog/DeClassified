/***************************************
*   Filename: init-vu-meter-analog.m   *
*   Version:  1.3                      *
*   Created:  2017-08-17               *
*   Updated:  2020-02-20               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "init-vu-meter-analog.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_vu_meter_analog;

Function initializeAttributeVuMeterAnalog();

initializeAttributeVuMeterAnalog()
{
	initializeCustomPages();
	
	attribute_vu_meter_analog=custom_page.newAttribute("VU Meter Analog","0");
}
attribute_vu_meter_analog.onDataChanged()
{
	if (attribute_vu_meter_analog.getData()=="1")
	{
		displayInfo("showinfo","OPEN VU METER ANALOG");
		System.getContainer("vu.meter.analog").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE VU METER ANALOG");
		System.getContainer("vu.meter.analog").hide();
	}
}
/*************************************************
*   Filename: init-vu-meter-digital-vertical.m   *
*   Version:  1.8                                *
*   Created:  2017-08-17                         *
*   Updated   2020-02-20                         *
*   Author:   PeterK.                            *
*   E-Mail:   peter_ka@gmx.net                   *
*************************************************/

#ifndef included
#error This script "init-vu-meter-digital-vertical.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_vu_meter_digital_vertical;

Function initializeAttributeVuMeterDigitalVertical();

initializeAttributeVuMeterDigitalVertical()
{
	initializeCustomPages();
	
	attribute_vu_meter_digital_vertical=custom_page.newAttribute("VU Meter Digital Vertical","0");
	addMenuSeparator(custom_page);
}
attribute_vu_meter_digital_vertical.onDataChanged()
{
	if (attribute_vu_meter_digital_vertical.getData()=="1")
	{
		displayInfo("showinfo","OPEN VU METER DIGITAL VER.");
		System.getContainer("vu.meter.digital.vertical").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE VU METER DIGITAL VER.");
		System.getContainer("vu.meter.digital.vertical").hide();
	}
}
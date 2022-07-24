/***************************************************
*   Filename: init-vu-meter-digital-horizontal.m   *
*   Version:  1.4                                  *
*   Created:  2019-08-19                           *
*   Updated   2020-02-20                           *
*   Author:   PeterK.                              *
*   E-Mail:   peter_ka@gmx.net                     *
***************************************************/

#ifndef included
#error This script "init-vu-meter-digital-horizontal.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_vu_meter_digital_horizontal;

Function initializeAttributeVuMeterDigitalHorizontal();

initializeAttributeVuMeterDigitalHorizontal()
{
	initializeCustomPages();
	
	attribute_vu_meter_digital_horizontal=custom_page.newAttribute("VU Meter Digital Horizontal","0");
}
attribute_vu_meter_digital_horizontal.onDataChanged()
{
	if (attribute_vu_meter_digital_horizontal.getData()=="1")
	{
		displayInfo("showinfo","OPEN VU METER DIGITAL HOR.");
		System.getContainer("vu.meter.digital.horizontal").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE VU METER DIGITAL HOR.");
		System.getContainer("vu.meter.digital.horizontal").hide();
	}
}
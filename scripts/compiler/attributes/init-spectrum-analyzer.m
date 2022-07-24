/*****************************************
*   Filename: init-spectrum-analyzer.m   *
*   Version:  1.3                        *
*   Created:  2017-11-09                 *
*   Updated   2020-02-18                 *
*   Author:   PeterK.                    *
*   E-Mail:   peter_ka@gmx.net           *
*****************************************/

#ifndef included
#error This script "init-spectrum-analyzer.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_spectrum_analyzer;

Function initializeAttributeSpectrumAnalyzer();

initializeAttributeSpectrumAnalyzer()
{
	initializeCustomPages();
	
	attribute_spectrum_analyzer=custom_page.newAttribute("Spectrum Analyzer","0");
}
attribute_spectrum_analyzer.onDataChanged()
{
	if (attribute_spectrum_analyzer.getData()=="1")
	{
		displayInfo("showinfo","OPEN SPECTRUM ANALYZER");
		System.getContainer("spectrum.analyzer").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE SPECTRUM ANALYZER");
		System.getContainer("spectrum.analyzer").hide();
	}
}
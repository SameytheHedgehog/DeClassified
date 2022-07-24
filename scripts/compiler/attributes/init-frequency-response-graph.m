/************************************************
*   Filename: init-frequency-response-graph.m   *
*   Version:  1.3                               *
*   Created:  2018-04-14                        *
*   Updated   2020-02-18                        *
*   Author:   PeterK.                           *
*   E-Mail:   peter_ka@gmx.net                  *
************************************************/

#ifndef included
#error This script "init-frequency-response-graph.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_frequency_response_graph;

Function initializeAttributeFrequencyResponseGraph();

initializeAttributeFrequencyResponseGraph()
{
	initializeCustomPages();
	
	attribute_frequency_response_graph=custom_page.newAttribute("Frequency Response Graph","0");
}
attribute_frequency_response_graph.onDataChanged()
{
	if (attribute_frequency_response_graph.getData()=="1")
	{
		displayInfo("showinfo","OPEN FREQUENCY RESPONSE GRAPH");
		System.getContainer("frequency.response.graph").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE FREQUENCY RESPONSE GRAPH");
		System.getContainer("frequency.response.graph").hide();
	}
}
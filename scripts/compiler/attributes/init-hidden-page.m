/***********************************
*   Filename: init-hidden-page.m   *
*   Version:  1.0                  *
*   Created:  2020-02-18           *
*   Updated   2020-02-18           *
*   Author:   PeterK.              *
*   E-Mail:   peter_ka@gmx.net     *
***********************************/

#ifndef included
#error This script "init-hidden-page.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

Global ConfigAttribute attribute_beats_per_minute;
Global ConfigAttribute attribute_notification;
Global ConfigAttribute attribute_playback_status;
Global ConfigAttribute attribute_songticker_scrolling;
Global ConfigAttribute attribute_visualizer;
Global ConfigAttribute attribute_visualizer_color;
Global ConfigAttribute attribute_visualizer_mode;
Global ConfigAttribute attribute_visualizer_oscilloscope_style;
Global ConfigAttribute attribute_visualizer_spectroscope_bandwidth;
Global ConfigAttribute attribute_visualizer_spectroscope_falloff_speed;
Global ConfigAttribute attribute_visualizer_spectroscope_peaks;
Global ConfigAttribute attribute_visualizer_spectroscope_peaks_falloff_speed;
Global ConfigAttribute attribute_vu_meter_digital;

Function initializeAttributeHiddenPage();

initializeAttributeHiddenPage()
{
	initializeCustomPages();
	
	attribute_beats_per_minute=custom_page_nonexposed.newAttribute("attribute_beats_per_minute","hide");
	attribute_notification=custom_page_nonexposed.newAttribute("attribute_notification","hide");
	attribute_playback_status=custom_page_nonexposed.newAttribute("attribute_playback_status","show_text");
	attribute_songticker_scrolling=custom_page_nonexposed.newAttribute("attribute_songticker_scrolling","off");
	attribute_visualizer=custom_page_nonexposed.newAttribute("attribute_visualizer","hide");
	attribute_visualizer_color=custom_page_nonexposed.newAttribute("attribute_visualizer_color","classic");
	attribute_visualizer_mode=custom_page_nonexposed.newAttribute("attribute_visualizer_mode","spectroscope");
	attribute_visualizer_oscilloscope_style=custom_page_nonexposed.newAttribute("attribute_visualizer_oscilloscope_style","dots");
	attribute_visualizer_spectroscope_bandwidth=custom_page_nonexposed.newAttribute("attribute_visualizer_spectroscope_bandwidth","wide_show_grid");
	attribute_visualizer_spectroscope_falloff_speed=custom_page_nonexposed.newAttribute("attribute_visualizer_spectroscope_falloff_speed","2");
	attribute_visualizer_spectroscope_peaks=custom_page_nonexposed.newAttribute("attribute_visualizer_spectroscope_peaks","hide");
	attribute_visualizer_spectroscope_peaks_falloff_speed=custom_page_nonexposed.newAttribute("attribute_visualizer_spectroscope_peaks_falloff_speed","2");
	attribute_vu_meter_digital=custom_page_nonexposed.newAttribute("attribute_vu_meter_digital","hide");
}
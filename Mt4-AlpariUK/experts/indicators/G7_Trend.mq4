//+------------------------------------------------------------------+
//|                                                     G7_Trend.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 Aqua
#property indicator_color2 Blue
#property indicator_color3 Yellow
#property indicator_color4 Green
#property indicator_color5 MediumOrchid
#property indicator_color6 Red
#property indicator_color7 White
#property indicator_color8 Black
#property indicator_width1 1
#property indicator_level1 -1
#property indicator_level2 1
#property indicator_level3 -3
#property indicator_level4 3
#include <k.mqh>

//---- input parameters
extern int       MA_fast=4;
extern int       MA_slow=40;
extern int       MA_method=1;
extern int       MA_applied_price=0;

int OneDay = 86400;
int OneHour = 3600;

double ExtMapBuffer0[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(0, ExtMapBuffer0);
   SetIndexBuffer(1, ExtMapBuffer1);
   SetIndexBuffer(2, ExtMapBuffer2);
   SetIndexBuffer(3, ExtMapBuffer3);
   SetIndexBuffer(4, ExtMapBuffer4);
   SetIndexBuffer(5, ExtMapBuffer5);
   SetIndexBuffer(6, ExtMapBuffer6);
   SetIndexLabel(0, "EUR");
   SetIndexLabel(1, "GBP");
   SetIndexLabel(2, "AUD");
   SetIndexLabel(3, "CAD");
   SetIndexLabel(4, "CHF");
   SetIndexLabel(5, "JPY");
   SetIndexLabel(6, "USD");
   IndicatorShortName("G7 Trend @ Fast " + MA_fast + " Slow " + MA_slow);
   IndicatorDigits(4);
   return (0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int    counted_bars=IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   for (int i = 0; i < limit; i++) {
      ExtMapBuffer0[i] = iG7( "EUR", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer1[i] = iG7( "GBP", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer2[i] = iG7( "AUD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer3[i] = iG7( "CAD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer4[i] = iG7( "CHF", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer5[i] = iG7( "JPY", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      ExtMapBuffer6[i] = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
   }
   return (0);
}
//+------------------------------------------------------------------+
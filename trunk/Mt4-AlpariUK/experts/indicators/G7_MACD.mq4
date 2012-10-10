//+------------------------------------------------------------------+
//|                                                      G7_MACD.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Green
#property indicator_color3 Gold
#property indicator_color4 Red

#include <G7.mqh>

//---- input parameters
extern int       MA_fast=4;
extern int       MA_slow=32;
extern int       MA_method=0;
extern int       MA_applied_price=0;
extern double    MACD_Sepa=0.3;

double   MacdBuffer0[];
double   MacdBuffer1[];
double   MacdBuffer2[];
double   MacdBuffer3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID);
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID);
   SetIndexBuffer(0,MacdBuffer0);
   SetIndexBuffer(1,MacdBuffer1);
   SetIndexBuffer(2,MacdBuffer2);
   SetIndexBuffer(3,MacdBuffer3);
   SetIndexLabel(0,"MACD0");
   SetIndexLabel(1,"MACD1");
   SetIndexLabel(2,"MACD2");
   SetIndexLabel(3,"MACD3");
   
   IndicatorShortName("G7_MACD" + MA_fast + "," + MA_slow + ")");
   IndicatorDigits(4);
//----
   return(0);
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
   int counted_bars=IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   double ig;
   for (int i = 0; i < limit; i++) {
      if( Symbol() == "EURUSD") {
         ig = iG7( "EUR", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "GBPUSD") {
         ig = iG7( "GBP", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "AUDUSD") {
         ig = iG7( "AUD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDCAD") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "CAD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDCHF") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "CHF", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      } else if( Symbol() == "USDJPY") {
         ig = iG7( "USD", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i ) - iG7( "JPY", 0, MA_fast, MA_slow, MA_method, MA_applied_price, i );
      }
             
      if( MathAbs(ig) > MACD_Sepa) {
         if( ig > 0)
            MacdBuffer1[i] = ig;
         else 
            MacdBuffer3[i] = ig;
      }
      else {
         if( ig > 0)
            MacdBuffer0[i] = ig;
         else
            MacdBuffer2[i] = ig;
      }
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


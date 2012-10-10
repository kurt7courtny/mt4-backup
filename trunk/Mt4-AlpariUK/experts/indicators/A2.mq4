//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

//---- input parameters
extern int HPeriod=3;
extern int LPeriod=3;

//---- buffers
double HighesBuffer[];
double LowesBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(2);
   SetIndexBuffer(0, HighesBuffer);
   SetIndexBuffer(1, LowesBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(0, 1);
   SetIndexShift(1, 1);
//---- name for DataWindow and indicator subwindow label
   short_name="std hl"+HPeriod+","+LPeriod;
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"low");
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
   {
      HighesBuffer[i]=iStdDev(NULL, NULL,HPeriod,0,MODE_LWMA,PRICE_HIGH,i);
      LowesBuffer[i]=iStdDev(NULL, NULL,LPeriod,0,MODE_LWMA,PRICE_LOW,i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
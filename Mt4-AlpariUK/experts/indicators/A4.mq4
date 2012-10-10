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
extern int HPeriod=32;
extern int LPeriod=32;
extern int SignalSMA=5;

//---- buffers
double MMBuffer[];
double SignalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(2);
   SetIndexBuffer(0, MMBuffer);
   SetIndexBuffer(1, SignalBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(0, 1);
   SetIndexShift(1, 1);
//---- name for DataWindow and indicator subwindow label
   short_name="HL";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"Signal");
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
      MMBuffer[i]=iMA(NULL, NULL,HPeriod,0,MODE_EMA,PRICE_CLOSE,i) - iMA(NULL, NULL,LPeriod,0,MODE_EMA,PRICE_CLOSE,i+5);
   }
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MMBuffer,Bars,SignalSMA,0,MODE_EMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+
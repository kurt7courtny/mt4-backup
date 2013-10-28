//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

//---- input parameters

extern int HEntry=300;
extern int LEntry=300;
extern int shift=1;

//---- buffers
double HighBuffer[];
double LowBuffer[];
int lastalert=0;

//int count=0;
int deinit()
  {
  /*
//----
   for(int i=count-1;count>=0;count--)
   {
      ObjectDelete("A6:"+Time[count]);
   }
//----
*/
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(2);
   SetIndexBuffer(0, HighBuffer);
   SetIndexBuffer(1, LowBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   //SetIndexShift(0, 1);
   //SetIndexShift(1, 1);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("HLEntry");
   SetIndexLabel(0,"Entry H");
   SetIndexLabel(1,"Entry L");
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   // + "@" + DoubleToStr(Bid,Digits) 
   //double price;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
   {
      HighBuffer[i]=Low[i+1]+Point*HEntry;
      LowBuffer[i] =High[i+1]-Point*LEntry;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
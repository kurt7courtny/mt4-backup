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
extern int HPeriod=5;
extern int LPeriod=5;
extern int SignalSMA=5;

//---- buffers
double MainBuffer[];
double SignBuffer[];
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
   SetIndexBuffer(0, MainBuffer);
   SetIndexBuffer(1, SignBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(0, 1);
   SetIndexShift(1, 1);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("SeaT_s1");
   SetIndexLabel(0,"SeaT_s1 Main");
   SetIndexLabel(1,"SeaT_s1 Signal");
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
      MainBuffer[i]=High[iHighest(NULL, 0, MODE_HIGH, HPeriod, i)]-Low[iLowest(NULL, 0, MODE_LOW, LPeriod, i)];
    /*  if( TimeDayOfWeek(Time[i])==1)
      {
         ObjectDelete("A6:"+Time[count]);
         ObjectCreate("A6:"+Time[count], OBJ_TREND, 0, Time[i], HighBuffer[i+1], Time[i], LowBuffer[i+1]);
         ObjectSet("A6:"+Time[count], OBJPROP_RAY, false);
         ObjectSet("A6:"+Time[count], OBJPROP_STYLE, STYLE_DASHDOT);
         count++;
      }
      */
   }
   for(i=0; i<limit; i++)
      SignBuffer[i]=iMAOnArray(MainBuffer,Bars,SignalSMA,0,MODE_EMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2
//---- indicator parameters
extern int FastEMA=3;
extern int SlowEMA=3;
extern int SignalSMA=3;
extern double Signal=0.15;
//---- indicator buffers
double     MacdBuffer[];
double     SignalBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      ObjectsDeleteAll();
//----
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,SignalSMA);
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("iBand("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"band");
   SetIndexLabel(1,"Signal");
   SetIndexShift(0, 1);
   SetIndexShift(1, 1);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++)
   {
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_LWMA,PRICE_HIGH,i)-iMA(NULL,0,SlowEMA,0,MODE_LWMA,PRICE_LOW,i);
      if(MacdBuffer[i]<Signal*iATR(NULL, PERIOD_D1, 1, i))
      {
         ObjectCreate( "Warn:" + i, OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("Warn:" + i, OBJPROP_ARROWCODE, 241);
      }
   }
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
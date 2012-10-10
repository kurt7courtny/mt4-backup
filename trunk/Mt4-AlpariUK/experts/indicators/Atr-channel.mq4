//+------------------------------------------------------------------+
//|                                                    Alligator.mq4 |
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
extern int AtrPeriod=3;
extern double AtrMulti=0.7;

//---- indicator buffers
double UpperBuffer[];
double LowerBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- line shifts when drawing
  // SetIndexShift(0,1);
  // SetIndexShift(1,1);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,UpperBuffer);
   SetIndexBuffer(1,LowerBuffer);
   
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   
//---- index labels
   SetIndexLabel(0,"Upper Channel");
   SetIndexLabel(1,"Lower Channel");
   
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Bill Williams' Alligator                                         |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- main loop
   for(int i=0; i<limit; i++)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      Print("Atr Range:", iATR(NULL,0,AtrPeriod,i+1));
      UpperBuffer[i]=Open[i]+iATR(NULL,0,AtrPeriod,i+1);
      LowerBuffer[i]=Open[i]-iATR(NULL,0,AtrPeriod,i+1);
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+


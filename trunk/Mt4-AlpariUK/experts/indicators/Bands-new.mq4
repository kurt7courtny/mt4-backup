//+------------------------------------------------------------------+
//|                                                        Bands.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 LightSeaGreen
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen
#property indicator_color4 LightSalmon
#property indicator_color5 LightSalmon
#property indicator_color6 LightSalmon

//---- indicator parameters
extern int    BandsPeriod=20;
extern int    BandsShift=0;
extern double BandsDeviations=2.0;
//---- buffers
double MovingBuffer1[];
double UpperBuffer1[];
double LowerBuffer1[];
double MovingBuffer2[];
double UpperBuffer2[];
double LowerBuffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(0,MovingBuffer1);
   SetIndexStyle(1,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(1,UpperBuffer1);
   SetIndexStyle(2,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(2,LowerBuffer1);
   SetIndexStyle(3,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(3,MovingBuffer2);
   SetIndexStyle(4,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(4,UpperBuffer2);
   SetIndexStyle(5,DRAW_LINE, EMPTY, 3);
   SetIndexBuffer(5,LowerBuffer2);
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
   SetIndexDrawBegin(3,BandsPeriod+BandsShift);
   SetIndexDrawBegin(4,BandsPeriod+BandsShift);
   SetIndexDrawBegin(5,BandsPeriod+BandsShift);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i;
   int    counted_bars=IndicatorCounted();
   double p1,p2;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
   {
      p1=iMA(NULL,0,BandsPeriod,BandsShift,MODE_SMA,PRICE_CLOSE,i);
      p2=iMA(NULL,0,BandsPeriod,BandsShift,MODE_SMA,PRICE_CLOSE,i+1);
      MovingBuffer1[i]=p1;
      MovingBuffer2[i]=p1;
      MovingBuffer1[i+1]=p2;
      MovingBuffer2[i+1]=p2;
      
      if(p1>p2)
      {
         MovingBuffer2[i]=EMPTY_VALUE;  
         MovingBuffer2[i+1]=EMPTY_VALUE;  
      }
      
      p1=iBands(NULL,NULL, BandsPeriod, BandsDeviations, BandsShift, PRICE_CLOSE, MODE_UPPER, i);
      p2=iBands(NULL,NULL, BandsPeriod, BandsDeviations, BandsShift, PRICE_CLOSE, MODE_UPPER, i+1);
      UpperBuffer1[i]=p1;
      UpperBuffer2[i]=p1;
      UpperBuffer1[i+1]=p2;
      UpperBuffer2[i+1]=p2;
      if(p1>p2)
      {
         UpperBuffer2[i]=EMPTY_VALUE;
         UpperBuffer2[i+1]=EMPTY_VALUE;
      }
      
      p1=iBands(NULL,NULL, BandsPeriod, BandsDeviations, BandsShift, PRICE_CLOSE, MODE_LOWER, i);
      p2=iBands(NULL,NULL, BandsPeriod, BandsDeviations, BandsShift, PRICE_CLOSE, MODE_LOWER, i+1);
      LowerBuffer1[i]=p1;
      LowerBuffer2[i]=p1;
      LowerBuffer1[i+1]=p2;
      LowerBuffer2[i+1]=p2;
      if(p1>p2)
      {
         LowerBuffer2[i]=EMPTY_VALUE;
         LowerBuffer2[i+1]=EMPTY_VALUE;
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


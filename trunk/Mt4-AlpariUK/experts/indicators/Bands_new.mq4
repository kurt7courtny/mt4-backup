//+------------------------------------------------------------------+
//|                                                        Bands.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Black
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen
#property indicator_color4 LightSeaGreen
#property indicator_color5 LightSeaGreen

//---- indicator parameters
extern int    BandsPeriod=20;
extern int    BandsShift=3;
extern double BandsDeviations=2.0;
//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];
double UpperBuffer2[];
double LowerBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MovingBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,LowerBuffer);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,UpperBuffer2);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,LowerBuffer2);
   
   SetIndexShift(0, BandsShift);
   SetIndexShift(1, BandsShift);
   SetIndexShift(2, BandsShift);
   SetIndexShift(3, BandsShift);
   SetIndexShift(4, BandsShift);
//----
   //SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   //SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   //SetIndexDrawBegin(2,BandsPeriod+BandsShift);
   //SetIndexDrawBegin(3,BandsPeriod+BandsShift);
   //SetIndexDrawBegin(4,BandsPeriod+BandsShift);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k,counted_bars=IndicatorCounted();
   double deviation;
   double sum,oldval,newres;
//----
   if(Bars<=BandsPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=BandsPeriod;i++)
        {
         MovingBuffer[Bars-i]=EMPTY_VALUE;
         UpperBuffer[Bars-i]=EMPTY_VALUE;
         LowerBuffer[Bars-i]=EMPTY_VALUE;
         UpperBuffer2[Bars-i]=EMPTY_VALUE;
         LowerBuffer2[Bars-i]=EMPTY_VALUE;
        }
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
      MovingBuffer[i]=iMA(NULL,0,BandsPeriod,0,MODE_SMA,PRICE_CLOSE,i);
//----
   i=Bars-BandsPeriod+1;
   if(counted_bars>BandsPeriod-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      sum=0.0;
      k=i+BandsPeriod-1;
      oldval=MovingBuffer[i];
      while(k>=i)
        {
         newres=Close[k]-oldval;
         sum+=newres*newres;
         k--;
        }
      deviation=BandsDeviations*MathSqrt(sum/BandsPeriod);
      UpperBuffer[i]=oldval+deviation;
      LowerBuffer[i]=oldval-deviation;
      UpperBuffer2[i]=(UpperBuffer[i]-LowerBuffer[i])*2/3+LowerBuffer[i];
      LowerBuffer2[i]=(UpperBuffer[i]-LowerBuffer[i])*1/3+LowerBuffer[i];
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
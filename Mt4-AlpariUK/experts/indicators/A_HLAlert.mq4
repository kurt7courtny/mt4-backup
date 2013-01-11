//+------------------------------------------------------------------+
//|                                                          ATR.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters
extern int HLPeriod=2;
extern int AtrPeriod=66;
extern double p1=0.7;
//---- buffers
double HLBuffer1[];
double HLBuffer2[];
double TempBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(3);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM,0,0,Blue);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,0,Red);
   //SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(0,HLBuffer1);
   SetIndexBuffer(1,HLBuffer2);
   SetIndexBuffer(2,TempBuffer);
   //SetIndexBuffer(2,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name=HLPeriod+"ÈÕ²¨¶¯Çø¼ä("+AtrPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,AtrPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
//+------------------------------------------------------------------+
int c=0;
int d=0;
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=AtrPeriod) return(0);
//---- initial zero
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      //HLBuffer1[i]=0.0;
      //HLBuffer2[i]=0.0;
      //TempBuffer[i]=1;
      TempBuffer[i]=High[iHighest(NULL,0,MODE_HIGH,HLPeriod,i)] - Low[iLowest(NULL,0,MODE_LOW,HLPeriod,i)];
      if(TimeYear(Time[i]) == Year())
         c+=1;
      //Print("Temp,",DoubleToStr(TempBuffer[i], 5),",i,",i);
      i--;
     }
   
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
   {
      double pp=p1*iMAOnArray(TempBuffer,Bars,AtrPeriod,0,MODE_SMA,i);
      if( pp<TempBuffer[i])
      {
         HLBuffer1[i]=TempBuffer[i];
         HLBuffer2[i]=0;
      }
      else
      {
         HLBuffer1[i]=0;
         HLBuffer2[i]=TempBuffer[i];  
         if(TimeYear(Time[i]) == Year())
            d+=1;
      }
   }
//   Print("c=",c," d=",d);
//----
   return(0);
  }
//+------------------------------------------------------------------+
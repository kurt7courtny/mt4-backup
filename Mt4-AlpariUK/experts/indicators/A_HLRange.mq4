//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Black

//---- input parameters
extern int HLPeriod=5;
extern int LongPeriod=60;
extern double PP=2;

//---- buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name="²¨¶¯Çø¼ä", in_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
   SetIndexBuffer(0, Buffer1);
   SetIndexBuffer(1, Buffer2);
   SetIndexBuffer(2, Buffer3);
   SetIndexBuffer(3, Buffer4);
   
//---- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM, EMPTY, EMPTY, indicator_color1);
   SetIndexStyle(1,DRAW_HISTOGRAM, EMPTY, EMPTY, indicator_color2);
   SetIndexStyle(2,DRAW_LINE, EMPTY, EMPTY, indicator_color3);
   SetIndexStyle(3,DRAW_LINE, EMPTY, EMPTY, indicator_color4);
   /*
   int d[8], index;
   //---- name for DataWindow and indicator subwindow label
   for(int i=0; i<200; i++)
   {
      index=(High[i]-Low[i])*10000/50;
      d[index]++;
      //Print("index:", index);
   }
   short_name="A_Atr";
   in_name="A_Atr:";
   for(i=0;i<8;i++)
   {
      in_name= in_name + DoubleToStr(i*50,0)+"-";
      in_name= in_name + DoubleToStr(i*50+50,0)+":";
      in_name= in_name + d[i] + ",";
   }
   Print(in_name);
   */
   IndicatorShortName(short_name + " HL Period: "+ DoubleToStr(HLPeriod,0)+ ", ATR * "+DoubleToStr(PP,1)+"   |___| ");

   SetIndexLabel(0,short_name+" HighLowB");
   SetIndexLabel(1,short_name+" HighLowR");
   SetIndexLabel(2,short_name+" ATRangeG");
   SetIndexLabel(3,short_name+" LongATRangeG");
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
      Buffer4[i]=1;//iATR(NULL, 0, LongPeriod,i+1);
      Buffer3[i]=PP*iATR(NULL, 0, HLPeriod,i+1);
      
      Print("bufer,"+DoubleToStr(Buffer4[i],4));
      Buffer1[i]=High[iHighest(NULL, 0, MODE_HIGH, HLPeriod, i+1)]-Low[iLowest(NULL, 0, MODE_LOW, HLPeriod, i+1)];
      Buffer2[i]=High[iHighest(NULL, 0, MODE_HIGH, HLPeriod, i+1)]-Low[iLowest(NULL, 0, MODE_LOW, HLPeriod, i+1)];
      if( (High[i]-Low[i])>Buffer3[i])
         Buffer1[i]=0;
      else
         Buffer2[i]=0;
      //Buffer3[i]=iATR(NULL, 0, 1, i+1);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
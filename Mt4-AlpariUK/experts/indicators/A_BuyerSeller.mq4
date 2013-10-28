//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Green
#property indicator_color3 Red

//---- input parameters
extern int p1=4;
extern double PP=2;

//---- buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name="Buyer And Seller", in_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
   SetIndexBuffer(0, Buffer1);
   SetIndexBuffer(1, Buffer2);
   SetIndexBuffer(2, Buffer3);
   
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);

   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name+"C-O");
   SetIndexLabel(1,short_name+"Buyer");
   SetIndexLabel(2,short_name+"Seller");
   
   SetLevelValue(0,0);
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
      Buffer1[i]=iMA(NULL,0,p1,1,MODE_SMA,PRICE_CLOSE,i)-iMA(NULL,0,p1,1,MODE_SMA,PRICE_OPEN,i);
      Buffer2[i]=iMA(NULL,0,p1,1,MODE_SMA,PRICE_HIGH,i)-iMA(NULL,0,p1,1,MODE_SMA,PRICE_OPEN,i);
      Buffer3[i]=iMA(NULL,0,p1,1,MODE_SMA,PRICE_LOW,i)-iMA(NULL,0,p1,1,MODE_SMA,PRICE_OPEN,i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
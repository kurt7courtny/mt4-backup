//+------------------------------------------------------------------+
//|                                                    A_k7range.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Orange


//---- input parameters ÍùÇ°×·ËÝÌìÊý
extern int HistoryPeriod=90;
//
extern int MPeriod=240;

//---- buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];
double lastime=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string short_name="k7range ", in_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(4);
   SetIndexBuffer(0, Buffer1);
   SetIndexBuffer(1, Buffer2);
   SetIndexBuffer(2, Buffer3);
   SetIndexBuffer(3, Buffer4);
   
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(3,DRAW_LINE);
   
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name+"now upper");
   SetIndexLabel(1,short_name+"M upper");
   SetIndexLabel(2,short_name+"now lower");
   SetIndexLabel(3,short_name+"M lower");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k=0,j=0,j2=0;
   int    counted_bars=IndicatorCounted();
   double price, price2;
//---- last counted bar will be recounted
   if(Period()>=PERIOD_D1) return;
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   //if(Volume[0]>1)return;
   //if(lastime==Time[0])return;
   //lastime=Time[0];
//---- signal line is simple movimg average
   //Print("limit:", limit);
   for(i=0; i<limit; i++)
   {
      price=0;
      price2=0;
      j=0;
      j2=0;
      for(k=0;k<HistoryPeriod;k++)
      {
         int ib=iBarShift(NULL, MPeriod, Time[i]-PERIOD_D1*k*60,true);
         if(ib!=-1)
         {
            price+=iHigh(NULL, MPeriod, ib)-iLow(NULL, MPeriod, ib);
            j++;       
         }     
         ib=iBarShift(NULL, 0, Time[i]-PERIOD_D1*k*60,true);
         if(ib!=-1)
         {
            price2+=High[ib]-Low[ib];
            j2++;       
         }     
      }
      
      Buffer1[i]=Open[iBarShift(NULL, 0, Time[i]/MPeriod/60*60*MPeriod)]+price/j;
      Buffer2[i]=0;//Open[i]+price2/j2;
      Buffer3[i]=Open[iBarShift(NULL, 0, Time[i]/MPeriod/60*60*MPeriod)]-price/j;
      Buffer4[i]=0;//Open[i]-price2/j2;
      
      //Print("B1,"+Buffer1[i]+","+Buffer3[i]+","+price+","+j);
    
   }
   return(0);
  }
//+------------------------------------------------------------------+
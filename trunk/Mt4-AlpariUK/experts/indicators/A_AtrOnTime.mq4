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
#property indicator_color2 Red
#property indicator_color3 Green

//---- input parameters ÍùÇ°×·ËÝÌìÊý
extern int HistoryPeriod=90;

//---- buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double lastime=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name="ÀúÊ·²¨¶¯Çø¼ä ", in_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
   SetIndexBuffer(0, Buffer1);
   SetIndexBuffer(1, Buffer2);
   SetIndexBuffer(2, Buffer3);
   
//---- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   
   SetLevelValue(0, 100*Point);
   SetLevelStyle(1, 1, Blue);
   //SetIndexShift(1, PERIOD_D1 / Period());
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
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name+"today");
   SetIndexLabel(1,short_name+"Avg in ("+HistoryPeriod+") Days");
   SetIndexLabel(2,short_name+"today");
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k=0,j=0;
   int    counted_bars=IndicatorCounted();
   double price;
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
      Buffer1[i]=iATR(NULL, NULL, 1, i);
      Buffer3[i]=Buffer1[i];
      j=0;
      for(k=0;k<HistoryPeriod;k++)
      {
         int ib=iBarShift(NULL, 0, Time[i]-PERIOD_D1*k*60,true);
         if(ib!=-1)
         {
            price+=High[ib]-Low[ib];
            j++;       
         }     
      }
      Buffer2[i]=price/j;
      
      if( Buffer2[i] < Buffer1[i])
         Buffer1[i]=0;
      else
         Buffer3[i]=0;
      //Print("bufer2,"+i+","+j+","+Buffer2[i]);
    
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
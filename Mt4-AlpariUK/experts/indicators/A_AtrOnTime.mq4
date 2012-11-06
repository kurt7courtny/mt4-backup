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

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name="ÀúÊ·²¨¶¯Çø¼ä ", in_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(2);
   SetIndexBuffer(0, Buffer1);
   SetIndexBuffer(1, Buffer2);
   
//---- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(1, PERIOD_D1 / Period());
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
//---- signal line is simple movimg average
   for(i=0; i<800; i++)
   {
      Buffer1[i]=iATR(NULL, NULL, 1, i);
      Buffer2[i]=0;
      for(k=0;k<HistoryPeriod;k++)
      {
         int ib=iBarShift(NULL, 0, Time[i]-PERIOD_D1*k,true);
         //Print("bufer2,"+ib+","+Buffer2[i]);
         if(ib!=-1)
         {
            Buffer2[i]+=High[ib]-Low[ib];
            j++;       
         }     
      }
      
      Buffer2[i]=Buffer2[i]/j;
    
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright ?2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window

//---- input parameters 往前追溯天数
extern int HistoryPeriod=90;
extern int cc=5;
//---- buffers

double lastime=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name="收缩突破";
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
   return(0);
  }

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
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k=0,j=0,f;
   int    counted_bars=IndicatorCounted();
   double p1, tprice, hprice, cprice=0;
//---- last counted bar will be recounted
   if(Period()>=PERIOD_D1) return;
   //if(Volume[0]>1)return;
   //if(lastime==Time[0])return;
   //lastime=Time[0];
//---- signal line is simple movimg average
   //Print("limit:", limit);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
   {
   cprice=0;
   for(f=1; f<=cc; f++)
   {
      if(iCustom(NULL, 0, "A_AtrOnTime", 90, 0, i+f)>0)
         cprice++;
   }
   if( cprice == cc && iCustom(NULL, 0, "A_AtrOnTime", 90, 2, i)>0)
   {
    lastime=Time[i];
    if( Close[i] > Open[i])
    {
       ObjectDelete( "AOTC" + TimeToStr(lastime));
       ObjectCreate( "AOTC" + TimeToStr(lastime), OBJ_ARROW, 0, Time[i], Low[i]-50*Point); 
       ObjectSet("AOTC" + TimeToStr(lastime), OBJPROP_ARROWCODE, 225);
    }
    else
    {
       ObjectDelete( "AOTC" + TimeToStr(lastime));
       ObjectCreate( "AOTC" + TimeToStr(lastime), OBJ_ARROW, 0, Time[i], High[i]+100*Point); 
       ObjectSet("AOTC" + TimeToStr(lastime), OBJPROP_ARROWCODE, 226);
    }
      
   }
   }
  //----
   return(0);
  }
//+-------------------------------------------------------
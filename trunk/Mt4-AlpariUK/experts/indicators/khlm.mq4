//+------------------------------------------------------------------+
//|                                                        Bands.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
//---- indicator parameters
extern int    mp=3;
extern int    md=0;
extern int    ms=1;
extern int    pd=PERIOD_H4;
int today=0, count=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(pd!=PERIOD_D1&&pd!=PERIOD_H4&&pd!=PERIOD_H1&&pd!=PERIOD_M30&&pd!=PERIOD_M15&&pd!=PERIOD_M5)
      pd=PERIOD_D1;
   
   return(0);
  }
int deinit()
  {
   for(int i=count-1;count>=0;count--)
   {
      ObjectDelete("hl:"+Time[count]);
      ObjectDelete("ll:"+Time[count]);
   }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   double h,l;

   for (int i = 0; i <= limit; i++)
   {
      int k = Time[i]/pd/60;
      if( today != k) {
         int b=iBarShift(NULL, pd, k*pd*60);
         h=iMA(NULL, pd, mp, ms, md, PRICE_HIGH, b);
         l=iMA(NULL, pd, mp, ms, md, PRICE_LOW, b); 
         ObjectDelete("hl:"+Time[count]);
         ObjectDelete("ll:"+Time[count]);
         ObjectCreate("hl:"+Time[count], OBJ_TREND, 0, k*pd*60, h, (k*pd+pd)*60, h);
         ObjectSet("hl:"+Time[count], OBJPROP_RAY, false);
         ObjectSet("hl:"+Time[count], OBJPROP_STYLE, STYLE_DASHDOT );
         //ObjectSet("hl:"+Time[count], OBJPROP_LEVELWIDTH, 3 );
         //ObjectSet("hl:"+Time[count], OBJPROP_WIDTH, 2);
         ObjectCreate("ll:"+Time[count], OBJ_TREND, 0, k*pd*60, l, (k*pd+pd)*60, l);
         ObjectSet("ll:"+Time[count], OBJPROP_RAY, false);
         ObjectSet("ll:"+Time[count], OBJPROP_STYLE, STYLE_DASHDOT );
         //ObjectSet("ll:"+Time[count], OBJPROP_LEVELWIDTH, 3 );
         //ObjectSet("ll:"+Time[count], OBJPROP_WIDTH, 2);
         count++;
         today=k;
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
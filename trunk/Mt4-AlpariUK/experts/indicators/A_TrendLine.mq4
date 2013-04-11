//+------------------------------------------------------------------+
//|                                                  A_TrendLine.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double  London_Open=7;
double  USA_Close=20;

double today;

int init()
  {
//---- indicators
//----
   if(Period()==PERIOD_H4)
   {
      USA_Close=16;
   }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(-1,OBJ_TREND);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
      int ib1, ib2, ia0, ia1, ia2, ia3, ia4, ia5;
      double lldate,ldate,lldatehigh,lldatelow, ldatehigh,ldatelow;
      if( Period() > PERIOD_D1)
         return(0);
      int    counted_bars=IndicatorCounted();
      if(counted_bars>0) counted_bars--;
      int limit=Bars-counted_bars;
      for(int i=0; i<limit; i++)
      {
      if( today != iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i])))
      {
         today=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i]));
         ldate=0;
         lldate=0;
         for(int j=0;j<PERIOD_D1/Period()*2+1;j++)
         {
          if(ldate==0&&Time[i+j]/86400*86400!=today)
            ldate=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]));
          if(lldate==0&&ldate!=0&&Time[i+j]/86400*86400!=ldate)
          {
            lldate=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]));
            //Print("lldate:", TimeToStr(lldate));
          }
         } 
       
         ia1 = iBarShift(NULL, 0, today);
         ia0 = ia1 - PERIOD_D1/Period();
         
         ib1 = iBarShift(NULL, 0, ldate+London_Open*3600);
         ib2 = iBarShift(NULL, 0, ldate+USA_Close*3600);
         
         ia2 = iHighest( NULL, 0, MODE_HIGH, ib1 - ib2, ib2);
         ia3 = iLowest( NULL, 0, MODE_LOW, ib1 - ib2, ib2);
         ldatehigh=High[ia2];
         ldatelow=Low[ia3];
         //Print("ldate:", TimeToStr(ldate)," lldate:", TimeToStr(lldate));
         //Print("ldate ", TimeToStr(Time[ia2])," ihigh", ldatehigh, " ib1 ", ib1, " ilow ", ldatelow);
         ib1 = iBarShift(NULL, 0, lldate+London_Open*3600);
         ib2 = iBarShift(NULL, 0, lldate+USA_Close*3600);
         
         ia4 = iHighest( NULL, NULL, MODE_HIGH, ib1 - ib2, ib2);
         ia5 = iLowest( NULL, NULL, MODE_LOW, ib1 - ib2, ib2);
         lldatehigh=High[ia4];
         lldatelow=Low[ia5];
         ObjectCreate("A Trend Line H:"+TimeToStr(today),2, 0,Time[ia1], lldatehigh-(lldatehigh-ldatehigh)*(ia1-ia4)/(ia2-ia4), today+86400,lldatehigh-(lldatehigh-ldatehigh)*(ia0-ia4)/(ia2-ia4));
         ObjectSet("A Trend Line H:"+TimeToStr(today), OBJPROP_RAY, false); 
         ObjectCreate("A Trend Line L:"+TimeToStr(today),2, 0,Time[ia1], lldatelow -(lldatelow -ldatelow )*(ia1-ia5)/(ia3-ia5), today+86400,lldatelow -(lldatelow -ldatelow )*(ia0-ia5)/(ia3-ia5));
         ObjectSet("A Trend Line L:"+TimeToStr(today), OBJPROP_RAY, false);
         ObjectSet("A Trend Line L:"+TimeToStr(today), OBJPROP_COLOR, Blue);
      }
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+
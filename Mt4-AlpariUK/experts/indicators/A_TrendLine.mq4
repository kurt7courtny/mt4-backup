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
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
      int ib, ib0, ib1, ib2, ib3, ib4;
      double lldate,ldate,lldatehigh,lldatelow, ldatehigh,ldatelow;
      if( Period() > PERIOD_D1)
         return(0);
      int    counted_bars=IndicatorCounted();
      if(counted_bars>0) counted_bars--;
      int limit=Bars-counted_bars;
      for(int i=0; i<3; i++)
      {
      if( today != iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i])))
      {
         today=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i]));
         ldate=0;
         lldate=0;
         for(int j=0;j<PERIOD_D1/Period()*2;j++)
         {
          if(ldate==0&&iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]))!=today)
            ldate=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]));
          if(lldate==0&&ldate!=0&&iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]))!=ldate)
            lldate=iTime(NULL, PERIOD_D1, iBarShift(NULL, PERIOD_D1, Time[i+j]));
         } 
       
         ib0 = iBarShift(NULL, 0, today);
         ib = ib0 - PERIOD_D1/Period();
         
         ib1 = iBarShift(NULL, 0, ldate+London_Open*3600);
         ib2 = iBarShift(NULL, 0, ldate+USA_Close*3600);
         ldatehigh=High[iHighest( NULL, NULL, MODE_HIGH, ib1 - ib2, ib2)];
         ldatelow=Low[iLowest( NULL, NULL, MODE_LOW, ib1 - ib2, ib2)];
         //Print("ldate ", TimeToStr(ldate)," ihigh", ldatehigh, " ib1 ", ib1, " ilow ", ldatelow);
         ib3 = iBarShift(NULL, 0, lldate+London_Open*3600);
         ib4 = iBarShift(NULL, 0, lldate+USA_Close*3600);
         lldatehigh=High[iHighest( NULL, NULL, MODE_HIGH, ib3 - ib4, ib4)];
         lldatelow=Low[iLowest( NULL, NULL, MODE_LOW, ib3 - ib4, ib4)];
         //Print("ldate ", TimeToStr(lldate)," ihigh", lldatehigh, " ib1 ", ib1, " ilow ", lldatelow);
      }
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+
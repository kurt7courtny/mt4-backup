//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
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
   int    limit;
   int    counted_bars=IndicatorCounted();
   //---- check for possible errors
   //Print("counted ", counted_bars);
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(int i=0;i<limit && Period() == PERIOD_D1;i++)
   {
      if( TimeDayOfWeek(Time[i]) == 1)
      {
         ObjectDelete( "arr" + TimeToStr(Time[i]));
         ObjectCreate( "arr" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("arr" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
      }   
   }

   return(0);
  }
//+------------------------------------------------------------------+
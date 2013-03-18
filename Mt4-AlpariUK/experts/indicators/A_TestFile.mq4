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
   for(int i=0;i<Bars && Period() == PERIOD_H4;i++)
   {
      if( MathAbs(Close[i] - Open[i]) < 0.001 && TimeHour(Time[i])!= 0 && TimeHour(Time[i]) != 20)
      {
         ObjectCreate( "arr" + i, OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("arr" + i, OBJPROP_ARROWCODE, 241);
      }   
   }
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
   Print("counted ", counted_bars);
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   return(0);
  }
//+------------------------------------------------------------------+
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
  
int count=0;
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
   for(int i=1;i<limit;i++)
   {
      if( High[i]>MathMax( MathMax(High[i+1],High[i+2]), Close[i+3]) && Low[i]<MathMin( MathMin(Low[i+1],Low[i+2]),Close[i+3]))
      {
         ObjectDelete( "a10" + TimeToStr(Time[i]));
         ObjectCreate( "a10" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("a10" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
         count+=1;
      }   
   }
   //Print("count=",count);
   return(0);
  }
//+------------------------------------------------------------------+
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


// ³¬¹ýµø·ù¶àÉÙ
double drange = 0.2;
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
   // Print("counted ", counted_bars);
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(int i=0;i<limit;i++)
   {
      double p1=MathAbs(Close[i]-Low[i])/(High[i]-Low[i]);
      double p2=MathAbs(Open[i]-High[i])/(High[i]-Low[i]);
      double p3=MathAbs(Open[i]-Low[i])/(High[i]-Low[i]);
      double p4=MathAbs(Close[i]-High[i])/(High[i]-Low[i]);
      ObjectDelete("oo"+Time[i]);
      if(( p1<drange && p2<drange) || (p3<drange && p4<drange))
      {  
         ObjectCreate( "oo" + Time[i], OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("oo" + Time[i], OBJPROP_ARROWCODE, 251);
      }   
   }
   return(0);
  }
//+------------------------------------------------------------------+
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
extern int numb=4;
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
   //if(Volume[0]>1) return;
   for(int i=0;i<limit;i++)
   {
      bool up=true, down=true;
      for(int j=1;j<=numb;j++)
      {  
         up=up&&(Close[j+i]>Close[j+i+1]);
         down=down&&(Close[j+i]<Close[j+i+1]);
      }   
      if(up||down)
      {
         ObjectDelete( "OneD" + TimeToStr(Time[i]));
         ObjectCreate( "OneD" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
         ObjectSet("OneD" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
      }
   }

   return(0);
  }
//+------------------------------------------------------------------+
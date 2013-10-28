//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

double p1=0.8, p2=0.2;
int p3=15, p4=20;
string strname="20-80:";
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
      double datr=High[i]-Low[i], dco=Close[i]-Open[i];
      if( dco > 0)
      {
         if( (Close[i]-Low[i])/datr > p1 && (Open[i]-Low[i])/datr < p2)// && Close[i] > High[iHighest(NULL,0,MODE_HIGH,p3,2+i)] && iHighest(NULL,0,MODE_HIGH,p3,2+i)==iHighest(NULL,0,MODE_HIGH,p4,2+i))// )
         {
            ObjectDelete( strname + TimeToStr(Time[i]));
            ObjectCreate( strname + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);     
         }
      }
      else
      {
         if( (Close[i]-Low[i])/datr < p2 && (Open[i]-Low[i])/datr > p1)// && Close[i] < Low[iLowest(NULL,0,MODE_LOW,p3,2+i)] && iLowest(NULL,0,MODE_LOW,p3,2+i)==iLowest(NULL,0,MODE_LOW,p4,2+i))// )
         {
            ObjectDelete( strname + TimeToStr(Time[i]));
            ObjectCreate( strname + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 242);     
         }
      }
   }
   //Print("count=",count);
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

double p1=0.8, p2=0.2;
int p3=18, p4=20;
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
   int    limit,ih1,ih2,il1,il2;
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
      //if( dco > 0)
      {
         //if( (Close[i]-Low[i])/datr > p1 && (Open[i]-Low[i])/datr < p2)//
         ih1=iHighest(NULL,0,MODE_HIGH,p3,1+i);  
         ih2=iHighest(NULL,0,MODE_HIGH,p4,1+i);  
         if( High[i] > High[ih1] && ih1==ih2 && ih1!=i+1 )
         {
            //Print("ihight,", iHighest(NULL,0,MODE_HIGH,p3,1+i));
            ObjectDelete( strname + TimeToStr(Time[i]));
            ObjectCreate( strname + TimeToStr(Time[i]), 2, 0, Time[i-3], High[ih1], Time[ih1+3], High[ih1]); 
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_RAY, false); 
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_COLOR, Yellow); 
            //ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);     
         }
      }
      //else
      {
         il1=iLowest(NULL,0,MODE_LOW,p3,1+i);
         il2=iLowest(NULL,0,MODE_LOW,p4,1+i);
         //if( (Close[i]-Low[i])/datr < p2 && (Open[i]-Low[i])/datr > p1 && 
         if( Low[i] < Low[il1] && il1==il2 && il1!=i+1 )
         {
            ObjectDelete( strname + TimeToStr(Time[i]));
            ObjectCreate( strname + TimeToStr(Time[i]), 2, 0, Time[i-3], Low[il1], Time[il1+3], Low[il1]); 
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_RAY, false);     
            ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_COLOR, Yellow); 
         }
      }
   }
   //Print("count=",count);
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

extern int p3=4, p4=6;
extern color cor1=Black;
string strnameh="20-80h:";
string strnamel="20-80l:";
int t1=0,t2=0,py=0;

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
   for(int i=limit;i>0;i--)
   {
      
      if(py!=TimeYear(Time[i])-1)
      {
         py=TimeYear(Time[i])-1;
         Print("C:"+Symbol()+"year: " + py +" t1: "+t1+" t2: "+t2);
         t1=0;
         t2=0;
      }
      
      {
         //if( (Close[i]-Low[i])/datr > p1 && (Open[i]-Low[i])/datr < p2)//
         ih1=iHighest(NULL,0,MODE_HIGH,p3,1+i);  
         ih2=iHighest(NULL,0,MODE_HIGH,p4,1+i);  
         il1=iLowest(NULL,0,MODE_LOW,p3,1+i);
         il2=iLowest(NULL,0,MODE_LOW,p4,1+i);
         double tt1=0.001;
         if( High[i+1] < High[i+2] && High[i+1] + tt1 > High[i+2] && High[i] > High[i+1] - tt1 )
         {
            //Print("ihight,", iHighest(NULL,0,MODE_HIGH,p3,1+i));
            ObjectDelete( strnameh + TimeToStr(Time[i]));
            if(i-3>0)
               ObjectCreate( strnameh + TimeToStr(Time[i]), 2, 0, Time[i+2], High[i+2], Time[i], High[i+1]); 
            else
               ObjectCreate( strnameh + TimeToStr(Time[i]), 2, 0, Time[0], High[ih1], Time[ih1+3], High[ih1]); 
            ObjectSet(strnameh + TimeToStr(Time[i]), OBJPROP_RAY, false); 
            ObjectSet(strnameh + TimeToStr(Time[i]), OBJPROP_COLOR, cor1); 
            t1++;
            //ObjectSet(strname + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);     
         }
      }
      //else
      {
         
         //if( (Close[i]-Low[i])/datr < p2 && (Open[i]-Low[i])/datr > p1 && 
         if( Low[i+1] > Low[i+2] && Low[i+1] - tt1 < Low[i+2] && Low[i] < Low[i+1] + tt1)
         {
            ObjectDelete( strnamel + TimeToStr(Time[i]));
            if(i-3>0)
               ObjectCreate( strnamel + TimeToStr(Time[i]), 2, 0, Time[i+2], Low[i+2], Time[i], Low[i+1]); 
            else
               ObjectCreate( strnamel + TimeToStr(Time[i]), 2, 0, Time[0], Low[il1], Time[il1+3], Low[il1]); 
            ObjectSet(strnamel + TimeToStr(Time[i]), OBJPROP_RAY, false);     
            ObjectSet(strnamel + TimeToStr(Time[i]), OBJPROP_COLOR, cor1); 
            t2++;
         }
      }
   }
   //Print("count=",count);
   return(0);
  }
//+------------------------------------------------------------------+
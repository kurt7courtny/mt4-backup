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
      s1();
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
   /*
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
   */
   //Print("count=",count);
   return(0);
  }
//+------------------------------------------------------------------+

// ma judge trend 
int s1()
{
   int t1=0, t2=0, tdu=0, tdd=0, tud=0, tuu=0, tv1=0, tv2=0, tf1=0, tf2=0;
   for( int i=0; i < Bars;i++)
   {
      double ma=iMA(NULL, NULL, 16, 1, MODE_SMA, PRICE_CLOSE, i);
      // down trend
      if(Open[i] < ma)
      {
         t1+=1;
         if( Close[i]>Open[i])
            tdu+=1;
         else
            tdd+=1;
         if( High[i]>High[i+1] && Close[i]<Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], High[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 242);
            tv1+=1;
         }
         if( High[i]>High[i+1] && Close[i]>Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], High[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 68);
            tf1+=1;
         }
      }
      else
      {
         t2+=1;
         if( Close[i]>Open[i])
            tuu+=1;
         else
            tud+=1;
         if( Low[i]<Low[i+1] && Close[i]>Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
            tv2+=1;
         }
         if( Low[i]<Low[i+1] && Close[i]<Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 67);
            tf2+=1;
         }
      }   
   }
   Print( Symbol() + ": Total: " + Bars + " days,td:"+t1+" tu:"+t2+" tdd:"+tdd+" tdu:"+tdu+" tud:"+tud+" tuu:"+tuu+" tdv:"+tv1+" tuv:"+tv2+" tdf:"+tf1+" tuf:"+tf2);
   return(0);
}
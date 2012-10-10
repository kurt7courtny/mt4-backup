//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
int lasthigh=0, lastlow=0;
bool buptrend=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   lasthigh=Time[Bars-1];
   lastlow=Time[Bars-1];
   buptrend=true;
   for(int i=0;i<Bars-1;i++)
   {
      ObjectDelete("Inside Day:"+TimeToStr(Time[i]));   
      ObjectDelete("High:"+TimeToStr(Time[i]));
      ObjectDelete("Low:"+TimeToStr(Time[i]));
   }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int i=0;i<Bars-1;i++)
   {
      ObjectDelete("Inside Day:"+TimeToStr(Time[i]));   
      ObjectDelete("High:"+TimeToStr(Time[i]));
      ObjectDelete("Low:"+TimeToStr(Time[i]));
   }
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
   limit=Bars-counted_bars-1;
   for(int i=limit;i>0;i--)
   {
    //inside Day
    //Print("i ", i);
    if(High[i]<High[i+1] && Low[i]>Low[i+1])
    {
      ObjectDelete("Inside Day:"+TimeToStr(Time[i]));
      ObjectCreate("Inside Day:"+TimeToStr(Time[i]),OBJ_ARROW, 0, Time[i], Low[i]); 
      ObjectSet("Inside Day:"+TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
      continue;
    }
    if(buptrend)
    {
     if(High[i]<High[iBarShift(NULL, NULL, lasthigh)])
     {
      ObjectDelete("High:"+TimeToStr(lasthigh));
      ObjectCreate("High:"+TimeToStr(lasthigh),OBJ_ARROW, 0, lasthigh, High[iBarShift(NULL, NULL, lasthigh)]*1.002); 
      ObjectSet("High:"+TimeToStr(lasthigh), OBJPROP_ARROWCODE, 251);
      //Print("lasthigh:", lasthigh);
      lastlow=Time[i];
      lasthigh=Time[i];
      buptrend=!buptrend;
      continue;  
     }
     else
     {
      lasthigh=Time[i];
     }
    }
    else
    {
     if(Low[i]>Low[iBarShift(NULL, NULL, lastlow)])
     {
      ObjectDelete("Low:"+TimeToStr(lastlow));
      ObjectCreate("Low:"+TimeToStr(lastlow),OBJ_ARROW, 0, lastlow, Low[iBarShift(NULL, NULL, lastlow)]); 
      ObjectSet("Low:"+TimeToStr(lastlow), OBJPROP_ARROWCODE, 251);
      lastlow=Time[i];
      lasthigh=Time[i];
      buptrend=!buptrend;
      continue;  
     }
     else
     {
      lastlow=Time[i];
     }
    }  
   }
   return(0);
  }
//+------------------------------------------------------------------+
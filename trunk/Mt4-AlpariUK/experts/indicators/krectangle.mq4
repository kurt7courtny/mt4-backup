//+------------------------------------------------------------------+
//|                                                   krectangle.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//--- input parameters
extern double    atrp=0.15;
extern int       reclength=20;
extern int       minwidth=250;
extern int       breakwidth=50;
extern bool      bAlert=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int count=0, lastime=0;
double lastu=0,lastl=0;
int init()
  {
//---- indicators
   IndicatorDigits(4);
   IndicatorShortName("krectangle");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int i=0;i<count;i++)
      ObjectDelete("rec"+i);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   double upper, lower;
   for (int i = limit; i >=0;i--) 
   {
      double rec=MathMax(iATR(NULL, PERIOD_D1, 3, (Time[0]-Time[i])/86400)*atrp, minwidth*Point);
      //Print("rec width:", rec, " mw:", minwidth*Point);
      upper=Open[iHighest(NULL, 0, MODE_OPEN, reclength, i)];
      lower=Open[ iLowest(NULL, 0, MODE_OPEN, reclength, i)];  
      //Print("upp:"+upper+"lower:"+lower+"lastime:"+TimeToStr(lastime)+"ss:"+TimeToStr(Time[i+reclength]));
      if( (upper-lower) < rec && lastime < Time[i+reclength])
      {  
         lastu=upper;
         lastl=lower;
         ObjectCreate("rec"+count, OBJ_RECTANGLE, 0, Time[i], Open[iHighest(NULL, 0, MODE_OPEN, reclength, i)], Time[i+reclength], Open[iLowest(NULL, 0, MODE_OPEN, reclength, i)]);
         lastime=Time[i];
         //Print("lastime", TimeToStr(lastime));
         i=i-reclength;
         count+=1;
      } 
   }
   for(int j=iBarShift( NULL, NULL, lastime);j>=0 && lastu!=0 && lastl !=0; j--)
   {
      Print("j="+j+" Time: "+TimeToStr(Time[j]));
      if( Close[j] < lastl - breakwidth*Point)
      {
         ObjectCreate("rec"+count, OBJ_ARROW, 0, Time[j], lastu + breakwidth*Point*5);
         ObjectSet("rec"+count, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
         if(bAlert)
            SendMail( Symbol()+ " Break Lower Band", "Channel: "+DoubleToStr(lastl, 4)+" ~ "+DoubleToStr(lastu,4)+" Price: "+DoubleToStr(Close[j],4)+" Time: "+TimeToStr(Time[j]));
         lastu=0;
         lastl=0;
         count+=1;
         break;
      }
      
      if( Close[j] > lastu + breakwidth*Point)
      {
         ObjectCreate("rec"+count, OBJ_ARROW, 0, Time[j], lastl - breakwidth*Point*5);
         ObjectSet("rec"+count, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
         ObjectSet("rec"+count, OBJPROP_COLOR, Lime);
         if(bAlert)
            SendMail( Symbol()+ " Break Upper Band", "Channel: "+DoubleToStr(lastl,4)+" ~ "+DoubleToStr(lastu,4)+" Price: "+DoubleToStr(Close[j],4)+" Time: "+TimeToStr(Time[j]));
         lastu=0;
         lastl=0;
         count+=1;   
         break;
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
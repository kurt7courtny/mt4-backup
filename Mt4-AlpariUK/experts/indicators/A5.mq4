//+----------------  --------------------------------------------------+
//|                                                   krectangle.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//--- input parameters
extern double    slope=0.005;
extern int       range=5;
extern int       ma=32;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int count=0, lastime=0;
bool found=false;
int init()
  {
//---- indicators
   IndicatorDigits(4);
   IndicatorShortName("ma slope");
   //for(int i=Bars-ma;i>=0;i--)
   for(int i=Bars;i>=0;i--)
   {
      double d1=iMA(NULL, NULL, ma, MODE_EMA, 1, PRICE_CLOSE, i);
      double d2=iMA(NULL, NULL, ma, MODE_EMA, 1, PRICE_CLOSE, i+range);
      double islope=d1-d2;
      //Print("d1,", d1, ",d2,", d2, ",islope,", islope);
      if( MathAbs(islope) > slope)
      {
         if(lastime==0)
            lastime=i; 
       
      }
      else
      {
         if(lastime!=0)
         {
            ObjectCreate("rec"+count, OBJ_RECTANGLE, 0, Time[i+1], High[iHighest(NULL, 0, MODE_HIGH, lastime-i, i+1)], Time[lastime], Low[iLowest(NULL, 0, MODE_LOW, lastime-i, i+1)]);
            ObjectSet("rec"+count, OBJPROP_COLOR, Indigo);
            count ++;
            lastime=0;  
         }
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
   /*
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
   */
//----
   return(0);
  }
//+------------------------------------------------------------------+
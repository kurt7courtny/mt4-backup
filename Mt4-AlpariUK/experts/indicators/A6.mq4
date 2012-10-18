//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

//---- input parameters

extern bool		EmailAlert	= false;
extern bool		PopupAlert	= false;

extern int HPeriod=4;
extern int LPeriod=4;

//---- buffers
double HighBuffer[];
double LowBuffer[];
int lastalert=0;

//int count=0;
int deinit()
  {
  /*
//----
   for(int i=count-1;count>=0;count--)
   {
      ObjectDelete("A6:"+Time[count]);
   }
//----
*/
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(2);
   SetIndexBuffer(0, HighBuffer);
   SetIndexBuffer(1, LowBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   //SetIndexShift(0, 1);
   //SetIndexShift(1, 1);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("SeaT");
   SetIndexLabel(0,"SeaT H");
   SetIndexLabel(1,"SeaT L");
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   string sMessage="Turtle " + Symbol() +" Cross ";
   // + "@" + DoubleToStr(Bid,Digits) 
   //double price;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
   {
      HighBuffer[i]=High[iHighest(NULL, 0, MODE_HIGH, HPeriod, i+1)];
      LowBuffer[i] =Low[iLowest(NULL, 0, MODE_LOW, LPeriod, i+1)];
      if( Open[0] > HighBuffer[1] && lastalert != Time[0])
      {
         sMessage = sMessage + DoubleToStr(HPeriod,0) + " High@" + DoubleToStr(Ask,Digits);
         if (PopupAlert) Alert(sMessage);
		   if (EmailAlert) SendMail("Alert CH " + Symbol(), sMessage);
         lastalert=Time[0];
      }
      
      if( Open[0] < LowBuffer[1] && lastalert != Time[0])
      {
         sMessage = sMessage + DoubleToStr(HPeriod,0) + " Low@" + DoubleToStr(Bid,Digits);
         if (PopupAlert) Alert(sMessage);
		   if (EmailAlert) SendMail("Alert CL " + Symbol(), sMessage);
         lastalert=Time[0];
      }
      // Print("lasth:"+HighBuffer[1]+" lastl:"+LowBuffer[1]);
    /*  if( TimeDayOfWeek(Time[i])==1)
      {
         ObjectDelete("A6:"+Time[count]);
         ObjectCreate("A6:"+Time[count], OBJ_TREND, 0, Time[i], HighBuffer[i+1], Time[i], LowBuffer[i+1]);
         ObjectSet("A6:"+Time[count], OBJPROP_RAY, false);
         ObjectSet("A6:"+Time[count], OBJPROP_STYLE, STYLE_DASHDOT);
         count++;
      }
      */
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
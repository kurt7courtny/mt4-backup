//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 MediumSpringGreen
#property indicator_color3 Red

//---- input parameters


extern bool		EmailAlert	= false;
extern bool		PopupAlert	= false;

extern int WEMA_Period = 14;
extern int WEMA_Shift = 0;

double WMABufferH[];
double WMABufferL[];
double WMABufferC[];
double WMABufferHO[];
double WMABufferLO[];
double WMABufferCO[];

//int count=0;
int deinit()
  {
   return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(6);
   SetIndexBuffer(0, WMABufferH);
   SetIndexBuffer(1, WMABufferL);
   SetIndexBuffer(2, WMABufferC);
   SetIndexBuffer(3, WMABufferHO);
   SetIndexBuffer(4, WMABufferLO);
   SetIndexBuffer(5, WMABufferCO);
//---- indicator lines
/*
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE, STYLE_DOT);
   SetIndexStyle(2,DRAW_LINE, STYLE_DASH);
   SetIndexStyle(3,DRAW_LINE, STYLE_DOT);
   SetIndexStyle(4,DRAW_LINE, STYLE_DASH);
   
   //SetIndexShift(0, 0);
   //SetIndexShift(1, 1);
   //SetIndexShift(2, 1);
   //SetIndexShift(3, 1);
   //SetIndexShift(4, 1);
*/   
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Welles Wilder Smoothing Moving Average");
   SetIndexLabel(0,"WMAH");
   SetIndexLabel(1,"WMAL");
   SetIndexLabel(2,"WMAC");
   /*
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, -100);
   SetIndexEmptyValue(2, -100);
   SetIndexEmptyValue(3, 100);
   SetIndexEmptyValue(4, 100);
   SetLevelValue(0,0);
   */
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
/*
DTO:C-MA((H+L)/2,8);
REF(HHV(DTO,55),1),COLORRED;
REF(LLV(DTO,55),1),COLORRED;
REF(HHV(DTO,55),56),COLORGREEN;
REF(LLV(DTO,55),56),COLORGREEN;
*/
//---- 
   for(i=0; i<limit; i++)
   {
      WMABufferHO[i]=High[i]/WEMA_Period+High[i+1]*(WEMA_Period-1)/WEMA_Period;
      WMABufferLO[i]=Low[i]/WEMA_Period+Low[i+1]*(WEMA_Period-1)/WEMA_Period;
      WMABufferCO[i]=Close[i]/WEMA_Period+Close[i+1]*(WEMA_Period-1)/WEMA_Period;
   }
   
   for(i=0; i<limit; i++)
   {
      WMABufferH[i]=iMAOnArray(WMABufferHO, 0, WEMA_Period, WEMA_Shift, MODE_EMA, i);
      WMABufferL[i]=iMAOnArray(WMABufferLO, 0, WEMA_Period, WEMA_Shift, MODE_EMA, i);
      WMABufferC[i]=iMAOnArray(WMABufferCO, 0, WEMA_Period, WEMA_Shift, MODE_EMA, i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
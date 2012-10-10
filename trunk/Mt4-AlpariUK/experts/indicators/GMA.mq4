//+------------------------------------------------------------------+
//|                                                          GMA.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Gold
#property indicator_color2 Orange
#property indicator_color3 DarkOrange
#property indicator_color4 SteelBlue
#property indicator_color5 DodgerBlue
#property indicator_color6 SlateBlue
#property indicator_color7 HotPink
#property indicator_color8 SlateBlue

extern int MA0 = 12;
extern int MA1 = 48;
extern int MA2 = 120;

//---- buffers
double ExtMapBuffer0[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer0);   
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(1,ExtMapBuffer1);
   SetIndexStyle(2,DRAW_LINE,STYLE_DASH);
   SetIndexBuffer(2,ExtMapBuffer2);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer3);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(4,ExtMapBuffer4);
   SetIndexStyle(5,DRAW_LINE,STYLE_DASH);
   SetIndexBuffer(5,ExtMapBuffer5);
   SetIndexStyle(6,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(6,ExtMapBuffer6);
   SetIndexStyle(7,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(7,ExtMapBuffer7);
   MA0 = MA0 * 60 / Period();
   MA1 = MA1 * 60 / Period();
   MA2 = MA2 * 60 / Period();
   IndicatorShortName("GMA " + MA0 + "," + MA1 + "," + MA0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- main loop
   for(int i=0; i<limit; i++)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      double ima0 =iMA(NULL,0,MA0,0,MODE_SMA,PRICE_MEDIAN,i);
      double ima1 =iMA(NULL,0,MA1,0,MODE_SMA,PRICE_MEDIAN,i);
      double ima2 =iMA(NULL,0,MA2,0,MODE_SMA,PRICE_MEDIAN,i);
      if( ( ima0 < ima1 && ima1 < ima2) || (ima0 > ima1 && ima1 > ima2))
      {
         ExtMapBuffer0[i]=ima0;
         ExtMapBuffer1[i]=ima1;
         ExtMapBuffer2[i]=ima2;
      }
      else
      {
         ExtMapBuffer3[i]=ima0;
         ExtMapBuffer4[i]=ima1;
         ExtMapBuffer5[i]=ima2;
      }
      //ExtMapBuffer3[i]=iMA(NULL,0,MA3,0,MODE_SMA,PRICE_MEDIAN,i);
      //ExtMapBuffer4[i]=iMA(NULL,0,MA4,0,MODE_SMA,PRICE_MEDIAN,i);
      //ExtMapBuffer5[i]=iMA(NULL,0,MA5,0,MODE_SMA,PRICE_MEDIAN,i);
      //ExtMapBuffer6[i]=iMA(NULL,0,MA6,0,MODE_SMA,PRICE_MEDIAN,i);
      //ExtMapBuffer7[i]=iMA(NULL,0,MA7,0,MODE_SMA,PRICE_MEDIAN,i);
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
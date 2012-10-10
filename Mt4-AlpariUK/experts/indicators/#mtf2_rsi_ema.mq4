//+------------------------------------------------------------------+
//|                                                      rsi_ema.mq4 |
//|                                   Copyright © 2010, Thomas Liles |
//|                                       http://www.trendchaser.org |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Thomas Liles"
#property link      "http://www.trendchaser.org"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 DeepSkyBlue
#property indicator_color4 Orange
#property indicator_color5 MintCream
#property indicator_color6 Gray

#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 0
#property indicator_width6 2

#property indicator_level1 50
#property indicator_level2 30
#property indicator_level3 70

#property indicator_minimum 0
#property indicator_maximum 100
/////////////////////////////////////////////////////
extern string    txt1           = "faster rsi beyond slower";
extern bool    use_extra_rsi_filter           = true;

extern string    txt2           = "first time frame";
extern int    TimeFrame1        =  5;
extern int    ema1_period       =  9;
extern int    ema1_period2      =  20;
extern int    rsi_period1       = 20;
extern int    rsi_up1           = 50;
extern int    rsi_dn1           = 50;

extern string    txt3           = "second time frame";
extern int    TimeFrame2        =  30;
extern int    ema2_period       =  9;
extern int    ema2_period2      =  20;
extern int    rsi_period2       = 20;
extern int    rsi_up2           = 50;
extern int    rsi_dn2           = 50;



//////////////////////////////////////////////////////
double        ainterval        =  1;
bool     atrade_allowed        =  true;
double         aminutes        = 0,ainterval2; 
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_LINE);
  // SetIndexArrow(4,225);
   SetIndexBuffer(4,ExtMapBuffer5);
   //SetIndexEmptyValue(4,0.0);
   SetIndexStyle(5,DRAW_LINE);
   //SetIndexArrow(5,226);
   SetIndexBuffer(5,ExtMapBuffer6);
  // SetIndexEmptyValue(5,0.0);
//----

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
  int bar_shift1,bar_shift_1;
  double ma1,ma2,ma3,ma4,rsi1,rsi2;
  
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   
   
        for(int i=limit; i>=0; i--)
     {
       bar_shift1 = iBarShift(NULL,TimeFrame1,Time[i]);
       bar_shift_1 = iBarShift(NULL,TimeFrame2,Time[i]);

      ma1=iMA(NULL,TimeFrame1,ema1_period,0,MODE_EMA,PRICE_CLOSE,bar_shift1);
      ma2=iMA(NULL,TimeFrame1,ema1_period2,0,MODE_EMA,PRICE_CLOSE,bar_shift1);
      ma3=iMA(NULL,TimeFrame2,ema2_period,0,MODE_EMA,PRICE_CLOSE,bar_shift_1);
      ma4=iMA(NULL,TimeFrame2,ema2_period2,0,MODE_EMA,PRICE_CLOSE,bar_shift_1);
      rsi1=iRSI(NULL,TimeFrame1,rsi_period1,PRICE_CLOSE,bar_shift1);
      rsi2=iRSI(NULL,TimeFrame2,rsi_period2,PRICE_CLOSE,bar_shift_1);
      
       ExtMapBuffer5[i]=rsi1;
       ExtMapBuffer6[i]=rsi2;
       
     if (use_extra_rsi_filter){
     
     //---the rules--------------------------------------------- 
    if (    //  buy rules
            ma3>=ma4
          &&ma1>=ma2
          &&rsi1>rsi_up1
          &&rsi2>rsi_up2
          &&rsi1>rsi2
    ) {
    ExtMapBuffer1[i]=  rsi1;
    ExtMapBuffer3[i]=  rsi2;
   }
   
   
    if (    //  sell rules
            ma3<ma4
          &&ma1<ma2
          &&rsi1<rsi_dn1
          &&rsi2<rsi_dn2
          &&rsi1<rsi2
    ){
    ExtMapBuffer2[i]=  rsi1;
    ExtMapBuffer4[i]=  rsi2;
   }
   
   
  }
  //---added filter---------------------------------------------
    if (!use_extra_rsi_filter){
    if (ma3>=ma4&&ma1>=ma2&&rsi1>rsi_up1&&rsi2>rsi_up2) {
    ExtMapBuffer1[i]=  rsi1;
    ExtMapBuffer3[i]=  rsi2;
    } 
    if (ma3<ma4&&ma1<ma2&&rsi1<rsi_dn1&&rsi2<rsi_dn2){
    ExtMapBuffer2[i]=  rsi1;
    ExtMapBuffer4[i]=  rsi2;
    }
  }
   //---------------------------------------------------------------------
}
   return(0);
  }
//+------------------------------------------------------------------+
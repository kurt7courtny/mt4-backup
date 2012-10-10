//+------------------------------------------------------------------+
//|                                                         OsMA.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"

//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1 White
#property  indicator_color2 Blue
#property  indicator_color3 Yellow
#property  indicator_color4 Green
#property  indicator_width1 2
#property  indicator_maximum 103
#property  indicator_level1 33
#property  indicator_level2 9

//---- indicator parameters
extern int MAS=0;
extern int MAE=100;
extern int MAM=0;
extern int MAP=0;
extern int MAL=800;

//---- indicator buffers
double     Buffer1[];
double     Buffer2[];
double     Buffer3[];
double     Buffer4[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(1);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
// SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(Digits+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,Buffer1);
   SetIndexBuffer(1,Buffer2);
   SetIndexBuffer(2,Buffer3);
   SetIndexBuffer(3,Buffer4);
   
   if( MAS > MAE || MAS < 0 || MAE < 0)
   {
      MAE=100;
      MAS=0;
   }

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MANumb("+MAS+","+MAE+","+MAM+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int limit, c1, c2, c3, c4;
   int counted_bars=IndicatorCounted();

//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
//---- macd counted in the 1-st additional buffer
   double ma, lower, upper;
   if( MAL > 0)
      limit=MathMin(limit, MAL);
   for(int i=0; i<limit; i++)
   {
      c1=0;
      c2=0;
      c3=0;
      c4=0;
      for( int j=MAS; j<MAE; j++)
      {
         ma=iMA(NULL,0,j,0,MAM,MAP,i);
         upper = MathMax( Open[i], Close[i]);
         lower = MathMin( Open[i], Close[i]);
         if( ma < High[i])
         {
            c1+= 1;
            if( ma < upper)
            {
               c2+=1;
               if( ma < lower)
               {
                  c3+=1;
                  if( ma < Low[i])
                  {
                     c4+=1;
                  }
               }
            }
         }
         
         //break;
      }
      Buffer1[i]=c1-c4;
      Buffer2[i]=c2;
      Buffer3[i]=c3;
      Buffer4[i]=c4;
   }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+


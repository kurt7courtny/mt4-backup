//+------------------------------------------------------------------+
//|                                                CrossedAlerts.mq4 |
//|                                                      Coders Guru |
//|                                         http://www.forex-tsd.com |
//+------------------------------------------------------------------+
#property copyright "Coders Guru"
#property link      "http://www.forex-tsd.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Orange

extern int tf1 = 5;
extern int FasterMA1 = 5;
extern int SlowerMA1 = 12;

extern int tf2 = 30;
extern int FasterMA2 = 5;
extern int SlowerMA2 = 12;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

double ExtMapBuffer3[];
double ExtMapBuffer4[];
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
   
   SetIndexStyle(2,DRAW_LINE,STYLE_DASH);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE,STYLE_DASH);
   SetIndexBuffer(3,ExtMapBuffer4);
   Print("using fast timeframe " + TimeFrameToStr(tf1) + " slow timeframe " + TimeFrameToStr(tf2)); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   
//----
   return(0);
  }

bool Crossed (double line1 , double line2 )
{

static string last_direction = "";
string current_dirction = "";

if(line1>line2)current_dirction = "up";
if(line1<=line2)current_dirction = "down";



if(current_dirction != last_direction) 
{
      Alert("EMA Cross for "+Symbol()+" on the "+Period()+" minute chart.");
      last_direction = current_dirction;
      return (true);
}
else
{
      return (false);

}
 
} 
int start()
  {
   int    counted_bars=IndicatorCounted();
 
//---- check for possible errors
   if (counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if (counted_bars>0) counted_bars--;
   
   int pos=Bars-counted_bars;
   
     
 
   while(pos>=0)
     {
         ExtMapBuffer1[pos]= iMA(NULL,tf1,FasterMA1,0,MODE_EMA,PRICE_CLOSE,pos);

         ExtMapBuffer2[pos]= iMA(NULL,tf1,SlowerMA1,0,MODE_EMA,PRICE_CLOSE,pos);

         ExtMapBuffer3[pos]= iMA(NULL,tf2,FasterMA2,0,MODE_EMA,PRICE_CLOSE,pos / (tf2 / tf1));
                  
         ExtMapBuffer4[pos]= iMA(NULL,tf2,SlowerMA2,0,MODE_EMA,PRICE_CLOSE,pos / (tf2 / tf1));
         
         pos--;
     }
     
     
     
     Print(Crossed (ExtMapBuffer1[0],ExtMapBuffer2[0]));


//----
   return(0);
  }
//+------------------------------------------------------------------+


//-------------------------------------------------------------------+
//---- TimeFrameToStr -----------------------------------------------+
//-------------------------------------------------------------------+
string TimeFrameToStr(int period)
  {
   switch(period)
     {
      case     1: string TimeFrameStr = "M1";          break;
      case     5:        TimeFrameStr = "M5";          break;
      case    15:        TimeFrameStr = "M15";         break;
      case    30:        TimeFrameStr = "M30";         break;
      case    60:        TimeFrameStr = "H1";          break;
      case   240:        TimeFrameStr = "H4";          break;
      case  1440:        TimeFrameStr = "D1";          break;
      case 10080:        TimeFrameStr = "W1";          break;
      case 43200:        TimeFrameStr = "MN1";         break;
      default:           TimeFrameStr = TimeFrameToStr(Period());
     }
     Print("convert " + period + " to time frame " + TimeFrameStr);
   return(TimeFrameStr);
  }


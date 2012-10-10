//+------------------------------------------------------------------+
//|                                                Trend Trading.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DarkViolet
//---- input parameters
extern int       TrendPeriod=3;
//---- buffers
double ExtMapBuffer1[];

int recount;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   recount = 0;
//----
    return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      for(int i=0;i< recount;i++)
      {
         ObjectDelete( "rec"+i);
      }
      Print("object removed ", recount);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   bool bup, bdown;
   int    limit;
   int    counted_bars=IndicatorCounted();
   //---- check for possible errors
   Print("counted ", counted_bars);
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(int i=0;i<limit;i++)
   {
      int j=0;
      double duphigh, duplow;
      bup = true;
      bdown = true;
      while( bup && i + j < limit)
      {
         bup = bup && (Low[i+j] > Low[i+j+1]);
         j ++;
      }
      
      if( j > TrendPeriod)
      {
         ObjectCreate( "rec" + recount, OBJ_RECTANGLE, 0, Time[i], High[i], Time[i+j-1], Low[i+j-1]);
         recount ++;
         i += j;
         i --;
      }
      
      j=0;
      while( bdown && i + j < limit)
      {
         bdown = bdown && (High[i+j] < High[i+j+1]);
         j ++;
      }
      
      if( j > TrendPeriod)
      {
         ObjectCreate( "rec" + recount, OBJ_RECTANGLE, 0, Time[i], Low[i], Time[i+j-1], High[i+j-1]);
         ObjectSet( "rec" + recount, OBJPROP_COLOR, Red);
         recount++;
         i += j;
         i --;
      }
   } 
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
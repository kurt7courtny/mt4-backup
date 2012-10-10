//+------------------------------------------------------------------+
//|                                                A_find_patten.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2012, Kurt, V 1.0"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

// ss and hmr params
double ss_p1 = 0.2;
double ss_p2 = 0.3;

// time frame info

int today=0, count=0;

int init()
  {
//---- indicators
   clear_all();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   clear_all();
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   find_ss_hmr(limit);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

// find ss or hammer
int find_ss_hmr( int  limit)
{
   for (int i = 1; i <= limit; i++)
   {
      if( MathAbs( Close[i] - Open[i]) / (High[i]-Low[i]) < ss_p1 && ismaintime(Time[i]))
      {
         ObjectCreate("A:"+count, OBJ_TEXT, 0, Time[i], High[i] + 100 * Point);
         ObjectSetText("A:"+count, "SS");
         count++;
      }
   }  
   return(0);
}

// is main trading Time
bool ismaintime(datetime dt)
{
   if( TimeHour(dt)>= 8 && TimeHour(dt)<20)
      return (true);
   else
      return (false);
}

// int clear all
int clear_all()
{
   for(int i=count-1;i>=0;i--)
   {
      ObjectDelete("A:"+i);
   }
   return(0);
}
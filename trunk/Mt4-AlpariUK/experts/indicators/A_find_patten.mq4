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

extern color cor1=Black;
// ss and hmr params
string pname="test:";

int toyear=0, count=0,count1=0;

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
   if(toyear==0)
         toyear=TimeYear(Time[counted_bars]);
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
   for (int i = limit; i >= 1; i--)
   {
      if( Close[i+1] > Open[i+1] && High[i+1] - High[i+2] > 0 && High[i+1] - High[i+2] <0.001 )
      {
         ObjectDelete(pname+count);
         ObjectCreate(pname+count, OBJ_ARROW, 0, Time[i], High[i]+0.005); 
         ObjectSet(pname+count, OBJPROP_ARROWCODE, 242);
         count++;
         count1++;
         if(TimeYear(Time[i])!=toyear)
         {
            Print("Year "+toyear+" ,pattern: "+count1);
            toyear=TimeYear(Time[i]);
            count1=0;
         }
      }
      
      if( Close[i+1] < Open[i+1] && Low[i+1] - Low[i+2] < 0 && Low[i+1] - Low[i+2] >-0.001  )
      {
         ObjectDelete(pname+count);
         ObjectCreate(pname+count, OBJ_ARROW, 0, Time[i], Low[i]-0.005); 
         ObjectSet(pname+count, OBJPROP_ARROWCODE, 241);
         count++;
         count1++;
         if(TimeYear(Time[i])!=toyear)
         {
            Print("Year "+toyear+" ,pattern: "+count1);
            toyear=TimeYear(Time[i]);
            count1=0;
         }
      }
   }  
   return(0);
}

// int clear all
int clear_all()
{
   for(int i=count-1;i>=0;i--)
   {
      ObjectDelete(pname+i);
   }
   return(0);
}
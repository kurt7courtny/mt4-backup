//+------------------------------------------------------------------+
//|                                                     OnFriday.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      s1();
      s2();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      ObjectsDeleteAll();
//----
   return(0);
  }
  
int draw_arrow(double t, double pos, int arrowcode)
{
   ObjectDelete( "a_s" + TimeToStr(t)+"-"+DoubleToStr(arrowcode,0) );
   ObjectCreate( "a_s" + TimeToStr(t)+"-"+DoubleToStr(arrowcode,0), OBJ_ARROW, 0, t, pos); 
   ObjectSet( "a_s" + TimeToStr(t)+"-"+DoubleToStr(arrowcode,0), OBJPROP_ARROWCODE, arrowcode);
   return(0);
}

int print_array(string arrstring, double arr[])
{
   string pp=arrstring+" ";
   for(int i=0;i<ArraySize(arr);i++)
   {
      if( NormalizeDouble(arr[i], 0)==arr[i])
         pp=StringConcatenate(pp,", p",DoubleToStr(i,0),": ",DoubleToStr(arr[i],0));
      else
         pp=StringConcatenate(pp,", p",DoubleToStr(i,0),": ",arr[i]);
   }
   Print(pp);
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   return(0);
  }
//+------------------------------------------------------------------+

// ma judge trend all, uptrend, downtrend, uptrend u
int s1()
{
   double ss1[9];
   for( int i=0; i < Bars;i++)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      double ma=iMA(NULL, NULL, 16, 0, MODE_SMA, PRICE_CLOSE, i);
      ss1[0]++;
      if(Open[i]>ma)
      {
         ss1[1]++;
         if(Close[i]>Open[i])
         {
            ss1[3]++;
         }
         else
         {
            ss1[4]++;
         }
      }
      else
      {
         ss1[2]++;
         if(Close[i]>Open[i])
            ss1[5]++;
         else
            ss1[6]++;
      }
      
   }
   print_array("ma",ss1);
   return(0);
}

// ma judge trend all, uptrend, downtrend, uptrend u
int s2()
{
   double ss2[9];
   for( int i=0; i < Bars;i++)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      double macd=iMACD(NULL, NULL, 5, 16, 1, PRICE_CLOSE, MODE_MAIN,i);
      ss2[0]++;
      if(macd>0.002)
      {
         ss2[1]++;
         if(Close[i]>Open[i])
         {
            ss2[3]++;
         }
         else
         {
            ss2[4]++;
         }
      }
      else
      {
         ss2[2]++;
         if(Close[i]>Open[i])
            ss2[5]++;
         else
            ss2[6]++;
      }
      
   }
   print_array("macd",ss2);
   return(0);
}
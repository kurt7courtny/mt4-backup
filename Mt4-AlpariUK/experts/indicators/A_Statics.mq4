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
double ss1[9];

int s1()
{
   ss1[0]=Bars;
   for( int i=0; i < Bars;i++)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      double ma=iMA(NULL, NULL, 16, 1, MODE_SMA, PRICE_CLOSE, i);
      if(Open[i]>ma)
      {
         ss1[1]++;
         if(Close[i]>Open[i])
         {
            ss1[3]+=Close[i]-Open[i];
            ss1[7]++;
         }
         else
         {
            ss1[4]+=Close[i]-Open[i];
            ss1[8]++;
         }
      }
      else
      {
         ss1[2]++;
         if(Close[i]<Open[i])
            ss1[5]+=Close[i]-Open[i];
         else
            ss1[6]+=Close[i]-Open[i]; 
      }
      
   }
   ss1[3]/=ss1[7];
   ss1[4]/=ss1[8];
   ss1[5]/=ss1[2];
   ss1[6]/=ss1[2];
      // down trend
      /*
      if(Open[i] < ma)
      {
         ss1[1]++;
         if( Close[i]>Open[i])
            tdu+=1;
         else
            tdd+=1;
         if( High[i]>High[i+1] && Close[i]<Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], High[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 242);
            tv1+=1;
         }
         if( High[i]>High[i+1] && Close[i]>Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], High[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 68);
            tf1+=1;
         }
      }
      else
      {
         t2+=1;
         if( Close[i]>Open[i])
            tuu+=1;
         else
            tud+=1;
         if( Low[i]<Low[i+1] && Close[i]>Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 241);
            tv2+=1;
         }
         if( Low[i]<Low[i+1] && Close[i]<Open[i])
         {
            ObjectDelete( "a_s" + TimeToStr(Time[i]));
            ObjectCreate( "a_s" + TimeToStr(Time[i]), OBJ_ARROW, 0, Time[i], Low[i]); 
            ObjectSet("a_s" + TimeToStr(Time[i]), OBJPROP_ARROWCODE, 67);
            tf2+=1;
         }
      }   
   }
   */
   print_array("ma",ss1);
   return(0);
}
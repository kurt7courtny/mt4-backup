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
      //s0();
      //s1();
      //s2();
      //s3();
      //s4();
      //s5();
      s6();
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
// 20 , 80 
int s0()
{
   double ub=0.8, lb=0.2, ss0[9];
   //Print("cp", Bars);
   for(int i=1;i<Bars-1;i++)
   {
      if( TimeYear(Time[i])<2013)
         continue; 
      double cp = (Close[i+1]-Low[i+1])/(High[i+1]-Low[i+1]), op = (Open[i+1]-Low[i+1])/(High[i+1]-Low[i+1]);
      ss0[0]++;
      //Print("cp", cp);
      if(cp>ub && op<lb)
      {
         ss0[1]++;
         if(High[i]>High[i+1])
         {
            if( Close[i] < High[i+1])
               ss0[3]++;
            else
               ss0[4]++;
            draw_arrow(Time[i], Low[i], 241);   
         }
      }
      
      if(cp<lb && op>ub)
      {
         ss0[2]++;
         if(Low[i]<Low[i+1])
         {
            if( Close[i] > Low[i+1])
               ss0[5]++;
            else 
               ss0[6]++;
            draw_arrow(Time[i], Low[i], 242);
         }
      }
   }   
   print_array("20-80",ss0);
   return(0);
}


// ma judge trend all, uptrend, downtrend, uptrend u
int s1()
{
   double ss1[9];
   for(int i=Bars;i>1;i--)
   {
      //if( TimeYear(Time[i])<2009)
      //   continue;
      double ma1=iMA(NULL, NULL, 16, 0, MODE_SMA, PRICE_CLOSE, i+1);
      double ma2=iMA(NULL, NULL, 16, 0, MODE_SMA, PRICE_LOW, i+1);
      ss1[0]++;
      if( High[i]>ma1 && Low[i]<ma1)
      {
         if(Close[i]>Open[i])
            ss1[1]++;
         else
            ss1[2]++;
      }
      
      /*
      if(Close[i]>ma1)
      {
         ss1[1]++;
         ss1[7]+=High[i]-Open[i];
         ss1[8]+=Open[i]-Low[i];
         if(Close[i]>Open[i])
         {
            ss1[3]++;  
         }
         else
         {
            ss1[4]++;
         }
      }
      else if(Close[i]<ma2)
      {
         ss1[2]++;
         if(Close[i]>Open[i])
            ss1[5]++;
         else
            ss1[6]++;
      }
      */
      
   }
   print_array("ma",ss1);
   return(0);
}

// ma judge trend all, uptrend, downtrend, uptrend u
int s2()
{
   double ss2[9];
   for(int i=Bars;i>1;i--)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      double macd=iMACD(NULL, NULL, 5, 16, 1, PRICE_CLOSE, MODE_MAIN,i+1);
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
      else if(macd<-0.002)
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

// turtles trend
int s3()
{
   int trend=0;
   double ss3[15];
   for(int i=Bars;i>1;i--)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      ss3[0]++;
      double max1=High[iHighest(NULL, 0, MODE_HIGH, 5, i+1)];
      double max2=High[iHighest(NULL, 0, MODE_HIGH, 2, i+1)];
      double min1=Low[iLowest(NULL, 0, MODE_LOW, 5, i+1)];
      double min2=Low[iLowest(NULL, 0, MODE_LOW, 2, i+1)];
      //Print("trend:",TimeToStr(Time[i]) +" , "+trend);
      if(trend>0)
      {
         ss3[1]++;
         //draw_arrow(Time[i], Low[i], 241);
         if(Close[i]>Open[i])
            ss3[4]++;
         else
            ss3[5]++;
         if(Low[i]<Low[i+1])
         {
            if(Close[i]>Open[i])
            {
               draw_arrow(Time[i], Low[i], 241);
               ss3[8]++;
            }
            else
            {
               draw_arrow(Time[i], Low[i], 242);
               ss3[9]++;
            }
         }
            
      }else if(trend<0)
      {
         ss3[2]++;
         if(Close[i]>Open[i])
            ss3[6]++;
         else
            ss3[7]++;
      //   if(High[i]>High[i+1])
      //    draw_arrow(Time[i], High[i], 89);
         
      }else
      {
         ss3[3]++;
      }
      
      if(Close[i]>max1)
      {
         
         trend=1;
      }
      if(Close[i]<min1)
      {
         //draw_arrow(Time[i], High[i], 242);
         trend=-1;
      }
      if( (Close[i]<min2&&trend==1) || (Close[i]>max2&&trend==-1))
      {
         //draw_arrow(Time[i], Low[i], 68);
         trend=0;
      }
      
      
   }
   print_array("turtle",ss3);
   return(0);
}


// turtles trans trend
int s4()
{
   int HPeriod=5, LPeriod=5, shift=5;
   double ss4[15];
   for(int i=Bars;i>1;i--)
   {
      if( TimeYear(Time[i])<2009)
         continue;
      ss4[0]++;
      double HighBuffer=High[iHighest(NULL, 0, MODE_HIGH, HPeriod, i+shift)];
      double LowBuffer =Low[iLowest(NULL, 0, MODE_LOW, LPeriod, i+shift)];
      if( Open[i]>HighBuffer)
      {
         ss4[1]++;
         if( Close[i]>Open[i])
            ss4[3]+=Close[i]-Open[i];
         else
            ss4[4]+=Close[i]-Open[i];
         
      }else if( Open[i]<LowBuffer)
      {
         ss4[2]++;
         if( Close[i]>Open[i])
            ss4[5]++;
         else
            ss4[6]++;
      }
   }
   print_array("trans turtle",ss4);
   return(0);
}

// custom break indicator statics
int s5()
{
   int cc=2;
   double ss5[9];
   int iflag=0;
   for(int i=Bars;i>1;i--)
   {
      //if( TimeYear(Time[i])<2013)
      //   continue;
      ss5[0]++;
      if(iCustom(NULL, 0, "A_HLRange", 5, 2, 0, i) < iCustom(NULL, 0, "A_HLRange", 5, 2, 1, i) && iCustom(NULL, 0, "A_HLRange", 5, 2, 1, i) < iCustom(NULL, 0, "A_HLRange", 5, 2, 1, i+1))
      {
         iflag++;        
         if(iflag==cc)
            draw_arrow(Time[i], Low[i], 242);
      }
      else
      {
         if(iflag>=cc)
         {
            ss5[1]++;     
         }
         iflag=0;
      }
   }
   print_array("custom break",ss5);
   return(0);
}

//+------------------------------------------------------------------+
// tt
int s6()
{
   double ub=0.8, lb=0.2, ss6[9], ma_period=19;
   //Print("cp", Bars);
   for(int i=1;i<Bars-1;i++)
   {
      if( TimeYear(Time[i])<2013)
         continue; 
      double ma = iMA( NULL, 0, ma_period, 1, MODE_SMA, PRICE_CLOSE, i);
      ss6[0]++;
      //Print("cp", cp);
      if(Open[i] < ma)
      {
         ss6[1]++;
         if(High[i]>High[i+1])
         {
            if( Close[i] < High[i+1])
               ss6[3]++;
            else
               ss6[4]++;
            draw_arrow(Time[i], Low[i], 241);   
         }
      }
      
      if(Open[i] > ma)
      {
         ss6[2]++;
         if(Low[i]<Low[i+1])
         {
            if( Close[i] > Low[i+1])
               ss6[5]++;
            else 
               ss6[6]++;
            draw_arrow(Time[i], Low[i], 242);
         }
      }
   }   
   print_array("ma",ss6);
   return(0);
}
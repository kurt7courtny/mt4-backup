//+------------------------------------------------------------------+
//|                                              ShmenTrendline.mq4  |
//|                                                            Bendo |
//|                                             "Creative Solutions" |
//|                                                                  |
//|PLEASE SEND PAYPAL DONATIONS AND MT4 CUSTOM PROGRAMMING           |
//|INQUIRIES TO BENDO@SHAW.CA                                        |
//+------------------------------------------------------------------+
#property copyright "bendo@shaw.ca"
#property link      ""
//----
#property indicator_chart_window
//---- input parameters
extern int mintouchp=3; //min bars in between swingpoints 
extern int lookback=500;  //maximum lookback for calculation in bars
extern int Shortest=10;  //shortest line allowed in bars
extern int breaktime=1;    //most recent bars ignored so you can see the break / bars allowed before a redraw after a break
extern int maxlines=4;     // maximum trendlines at once
extern double tol=0.1;     // the atr tolerance for spillover and touchpoints.
extern double tolP=200;    // the period bars for the atr calculation
extern double minD=2;      // min distance from line for each bounce in atr
extern bool anglefilter=false;  // if true: upper lines drawn downward only / lower lines drawn upward only
extern int maxage=100;     // maximum bars in the past allowed for the last touchpoint
extern string uppername="a"; // upper line name. change to ca for an alert on close when using shmen-dash http://www.forexfactory.com/showthread.php?t=198879
extern string lowername="b"; // lower line name. change to cb for an alert on close when using shmen-dash http://www.forexfactory.com/showthread.php?t=198879

int cnt,n=0,n2=0,n3=0;
bool DoneL = false,poke=false,thirdpoint=false;
datetime currentbar;
double r1,r2,curdif;
int rt1,rt2;
double s1,s2;
int st1,st2;
int forward,backward;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   for(cnt=0; cnt<=maxlines; cnt++)
     {

      if(cnt<maxlines)
        {
         ObjectCreate(lowername+cnt,OBJ_TREND,0,0,0,0,0);
         ObjectSet(lowername+cnt,OBJPROP_COLOR,Blue);
        }

      if(cnt<maxlines)
        {
         ObjectCreate(uppername+cnt,OBJ_TREND,0,0,0,0,0);
         ObjectSet(uppername+cnt,OBJPROP_COLOR,DarkGreen);
        }
     }
//----
   return(0);
  }

int deinit()
  {

   for(cnt=0; cnt<=maxlines; cnt++)
     {
      ObjectDelete(uppername+cnt);
      ObjectDelete(lowername+cnt);

     }

   return(0);
  }

int start()
  {

 if (currentbar != Time[0])
 {
   currentbar = Time[0];

   double Atol = iATR(NULL,0,tolP,1)*tol;
   double AminD = iATR(NULL,0,tolP,1)*minD;

   if(Bars<lookback) lookback=Bars-mintouchp;
   // Draw Lows!
   n=0;n2=0;n3=0;cnt=0;
   DoneL = false;poke=false;thirdpoint=false;
   for(n=Shortest; n<=lookback; n++)
     {
      if(Low[n]==Low[Lowest(NULL,0,MODE_LOW,mintouchp*2,n-mintouchp)])
        {
         for(n2=1; n2<n-Shortest+1; n2++)
            {
               if(Low[n2]==Low[Lowest(NULL,0,MODE_LOW,mintouchp*2,n2-mintouchp)])
                  {
                     s1=Low[n];
                     st1=n;
                     s2=Low[n2];
                     st2=n2;
                     ObjectMove(lowername+cnt,0,Time[st1],s1);
                     ObjectMove(lowername+cnt,1,Time[st2],s2);
                     poke = false;
                     thirdpoint = false;
                     for (n3=st1;n3>breaktime; n3--)
                        {
                         curdif = Low[n3] - ObjectGetValueByShift(lowername+cnt, n3);
                         if(curdif < 0-Atol)
                           {
                            poke = true;
                            break;
                           }
                         if(curdif >= 0-Atol && curdif <= Atol
                            && (n3 >= st1 + mintouchp || n3 <= st1 - mintouchp) 
                            && (n3 >= st2 + mintouchp || n3 <= st2 - mintouchp)
                            && Low[n3]==Low[Lowest(NULL,0,MODE_LOW,mintouchp*2,n3-mintouchp)]
                            && (s2 >= s1 || !anglefilter))
                           {
                            forward = st1 - n3;
                            backward = n3 - st2;   
                            if (High[Highest(NULL,0,MODE_HIGH,forward,st1)] - Low[n3] > AminD
                              &&  High[Highest(NULL,0,MODE_HIGH,backward,st1-backward)] - Low[n3] > AminD
                              && (n3 <= maxage || st2 <= maxage || st1 <= maxage))
                              thirdpoint = true;
                           }
                        }
                     if (!poke && thirdpoint) 
                        {
                        DoneL = true;
                        cnt++;
                        if (cnt > maxlines) break;
                        }
                     
                  }
            }
         if (cnt > maxlines) break;
        }
     }
     if (cnt <= maxlines) 
     {
      ObjectMove(lowername+cnt,0,1,0);
      ObjectMove(lowername+cnt,1,1,0); 
     }

   
   // Draw High!
   n=0;n2=0;n3=0;cnt=0;
   DoneL = false;poke=false;thirdpoint=false;
   for(n=Shortest; n<=lookback; n++)
     {
      if(High[n]==High[Highest(NULL,0,MODE_HIGH,mintouchp*2,n-mintouchp)])
        {
         for(n2=1; n2<n-Shortest+1; n2++)
            {
               if(High[n2]==High[Highest(NULL,0,MODE_HIGH,mintouchp*2,n2-mintouchp)])
                  {
                     r1=High[n];
                     rt1=n;
                     r2=High[n2];
                     rt2=n2;
                     ObjectMove(uppername+cnt,0,Time[rt1],r1);
                     ObjectMove(uppername+cnt,1,Time[rt2],r2);
                     poke = false;
                     thirdpoint = false;
                     for (n3=rt1;n3>breaktime; n3--)
                        {
                         curdif = ObjectGetValueByShift(uppername+cnt, n3) - High[n3];
                         if(curdif < 0-Atol)
                           {
                            poke = true;
                            break;
                           }
                         if(curdif >= 0-Atol && curdif <= Atol
                            && (n3 >= rt1 + mintouchp || n3 <= rt1 - mintouchp) 
                            && (n3 >= rt2 + mintouchp || n3 <= rt2 - mintouchp)
                            && High[n3]==High[Highest(NULL,0,MODE_HIGH,mintouchp*2,n3-mintouchp)]
                            && (r1 >= r2 || !anglefilter))
                           {
                            forward = rt1 - n3;
                            backward = n3 - rt2;   
                            if (High[n3] - Low[Lowest(NULL,0,MODE_LOW,forward,rt1)] > AminD
                              && High[n3] - Low[Highest(NULL,0,MODE_LOW,backward,rt1-backward)] > AminD
                              && (n3 <= maxage || rt2 <= maxage || rt1 <= maxage))
                              thirdpoint = true;
                           }
                        }
                     if (!poke && thirdpoint) 
                        {
                        DoneL = true;
                        cnt ++;
                        if (cnt > maxlines) break;

                        }
                     
                  }
            }
         if (cnt > maxlines) break;
        }
     }
   if (cnt <= maxlines) 
     {
      ObjectMove(uppername+cnt,0,1,0);
      ObjectMove(uppername+cnt,1,1,0);
     }
  }

   return(0);
  }


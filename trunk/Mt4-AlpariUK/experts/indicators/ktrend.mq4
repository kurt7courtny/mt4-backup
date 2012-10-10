//+------------------------------------------------------------------+
//|                                                       ktrend.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window

extern int kperiod=18;
extern int kstrong=16;
extern int kweak=10;
extern int ma=20;

extern int mac=3;
extern int malevel1=66;
extern int malevel2=33;

string CurrencyPairs[] = { "EURUSD", "GBPUSD", "AUDUSD", "USDCAD", "USDCHF", "NZDUSD",
                           "EURGBP", "EURAUD", "EURCAD", "EURCHF", "EURNZD", 
                           "GBPAUD", "GBPCAD", "GBPCHF",
                           "AUDCAD", "AUDCHF", "AUDNZD",
                           "CADCHF", "NZDCAD",
                           "NZDCHF",
                           "USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CADJPY", "CHFJPY",
                           "XAUUSD", "XAGUSD"
                           };
           
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int cpn;

int init()
  {
//---- indicators
//----
   IndicatorDigits(4);
   cpn = ArraySize(CurrencyPairs);
   IndicatorShortName("trend indi");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for( int i = 0; i < cpn; i++) {
      ObjectDelete( "ktrend_"+i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   //---- last counted bar will be recounted
   
   int ktrendup,ktrendown;
   for(int i=0;i<cpn;i++)
   {
      ktrendup=0;
      ktrendown=0;
      for(int j=1;j<=kperiod;j++)
      {
         double iH = iHigh(CurrencyPairs[i], PERIOD_H4, j);
         double iL = iLow( CurrencyPairs[i], PERIOD_H4, j);       
         double iM = iMA(CurrencyPairs[i], PERIOD_H4, ma, 0, MODE_SMA, PRICE_CLOSE, j);
         if(iM<iL)
            ktrendup+=1;
         if(iM>iH)
            ktrendown+=1;  
      }
      color objc;
      if(ktrendup+ktrendown>=kstrong)
      {
         if(ktrendup>=ktrendown)
            objc=LimeGreen;
         else 
            objc=Red;
      }
      else 
      {
         if(ktrendup+ktrendown>=kweak)
         {
            if(ktrendup>=ktrendown)
               objc=Green;
            else
               objc=Tomato;
         }
         else 
         {
            objc=Silver;
         }
      }
      
      double ma;
      string strma="";
      for(int k=mac-1;k>=0;k--)
      {
         int c=0;
         for( int l=0;l<100;l++)
         {
            ma=iMA(CurrencyPairs[i],PERIOD_M15,l,0,0,0,k);
            if(ma<iHigh(CurrencyPairs[i], PERIOD_M15, k)&&iLow(CurrencyPairs[i], PERIOD_M15, k)<ma)
            {
               c+=1;
            }
         }
         if(c>malevel2)
            strma=strma+"$";
         strma=strma+c+":";
      }
      ObjectCreate("ktrend_"+i, OBJ_LABEL, WindowFind("trend indi"), 0, 0);
      //+" lt:"+TimeToStr( iTime(CurrencyPairs[i], PERIOD_M15, 0))
      ObjectSetText("ktrend_"+i,CurrencyPairs[i] + "   Trend : " + DoubleToStr(ktrendup+ktrendown, 0)+" MA : "+strma,9, "Arial Bold", objc);
      ObjectSet("ktrend_"+i, OBJPROP_CORNER, 0);
      ObjectSet("ktrend_"+i, OBJPROP_XDISTANCE, 60 + i / 10 * 350);
      ObjectSet("ktrend_"+i, OBJPROP_YDISTANCE, 30 + i % 10 * 30);
   }

//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
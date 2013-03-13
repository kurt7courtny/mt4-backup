//+------------------------------------------------------------------+
//|                                                KDailyPercent.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

/***********************************************
*              DailyPercent
*  Find out the Pairs Goes To One Direction In One Day 
*
***********************************************/

#property indicator_separate_window

string CurrencyPairs[] = { "EURUSD", "GBPUSD", "AUDUSD", "USDCAD", "USDCHF", "NZDUSD",
                           "EURGBP", "EURAUD", "EURCAD", "EURCHF", "EURNZD", 
                           "GBPAUD", "GBPCAD", "GBPCHF",
                           "AUDCAD", "AUDCHF", "AUDNZD",
                           "CADCHF", //"NZDCAD",
                           //"NZDCHF",
                           "USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CADJPY", "CHFJPY"
                           
};

string Spreads[] = {"2.5", "2.8", "2.5", "2.8", "2.7", "3.2",
                    "2.7", "3.2", "4.0", "3.3", "6.6",
                    "4.5", "5.1", "5.0",
                    "3.9", "4.0", "4.9",
                    "9.9", //"",
                    //"",
                    "2.3", "3.0", "4.3", "3.0", "3.6", "3.6"};

string Indicators[] = { "Currency", "Spread", "Close", "2DaysH", "2DaysL", "2DaysR", "10DaysH", "10DaysL", "ADX(14)", "ADX_Dir", "MA22  ", "MA69  ", "MA123 ", "KD"};

int cpn,idn;
int Level = 15;

int xstep=100;
int xpos=100;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   IndicatorDigits(4);
   cpn = ArraySize(CurrencyPairs);
   idn = ArraySize(Indicators);
   IndicatorShortName("Total View");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete( "tv");
   for( int i = 0; i < cpn; i++) {
      for( int j=0;j < idn; j++)
         ObjectDelete( "tv."+CurrencyPairs[i]+"."+Indicators[j]);
   }
   for(j=0;j < idn; j++)
      ObjectDelete( "tv."+Indicators[j]);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   for(int i=0;i<idn;i++)
   {
      ObjectCreate("tv."+Indicators[i], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
      ObjectSetText("tv."+Indicators[i], Indicators[i],10, "Arial Bold", DeepPink);
      ObjectSet("tv."+Indicators[i], OBJPROP_CORNER, 0);
      ObjectSet("tv."+Indicators[i], OBJPROP_XDISTANCE, 95 + i * 100);
      ObjectSet("tv."+Indicators[i], OBJPROP_YDISTANCE, 35);
   }
   

   for(i = 0; i < cpn; i++) {
      xpos=xstep;
      handle2(i);
   }
   return(0);
  }
//+------------------------------------------------------------------+

// "2DaysH", "2DaysL", "2DaysR", "10DaysH", "10DaysL", "ADX(14)", "ADX_Dir", "MA22  ", "MA69  ", "MA123 ", "KD"};
//double p[100];
void handle2(int i)
{
   double para[100];
   para[2] = iClose(CurrencyPairs[i], PERIOD_D1,1);
   para[3] = MathMax(iClose(CurrencyPairs[i], PERIOD_D1,3), MathMax(iHigh(CurrencyPairs[i], PERIOD_D1,1), iHigh(CurrencyPairs[i], PERIOD_D1,2)));
   para[4] = MathMin(iClose(CurrencyPairs[i], PERIOD_D1,3), MathMin(iLow(CurrencyPairs[i], PERIOD_D1,1), iLow(CurrencyPairs[i], PERIOD_D1,2)));
   para[6] = iHigh(CurrencyPairs[i], PERIOD_D1, iHighest(CurrencyPairs[i], PERIOD_D1, MODE_HIGH, 10, 1));
   para[7] = iLow(CurrencyPairs[i], PERIOD_D1, iLowest(CurrencyPairs[i], PERIOD_D1, MODE_LOW, 10, 1));
   para[5] = (para[3] - para[4]);
   para[8] = iADX(CurrencyPairs[i], PERIOD_D1, 14, PRICE_CLOSE, MODE_MAIN,1);
   para[9] = iADX(CurrencyPairs[i], PERIOD_D1, 14, PRICE_CLOSE, MODE_MAIN,1)>iADX(CurrencyPairs[i], PERIOD_D1, 14, PRICE_CLOSE, MODE_MAIN,2);
   para[10] = iMA(CurrencyPairs[i], PERIOD_D1,22,0, MODE_SMA, PRICE_CLOSE, 1);
   para[11] = iMA(CurrencyPairs[i], PERIOD_D1,69,0, MODE_SMA, PRICE_CLOSE, 1);
   para[12] = iMA(CurrencyPairs[i], PERIOD_D1,123,0, MODE_SMA, PRICE_CLOSE, 1);
   para[13] = iStochastic(CurrencyPairs[i], PERIOD_D1,5,3,3,MODE_SMA,0,MODE_MAIN,1);
   
   
   //Draw Pair Name
   color cor;
   if( iClose(CurrencyPairs[i], PERIOD_D1, 1) > iOpen(CurrencyPairs[i], PERIOD_D1, 1))
      cor=Green;
   else
      cor=Red;
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[0], CurrencyPairs[i],9, "Arial Bold", cor);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   
   //Draw Spread
   string str="";
   if(i<ArraySize(Spreads))
      str=Spreads[i];
   else
      str="0";
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[1], str,9, "Arial Bold", DeepPink);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   
   //Draw Indicators
   for(int j=2;j<idn;j++)
   {
      ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[j], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
      ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[j], DoubleToStr( para[j], 4),9, "Arial Bold", Green);
      ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[j], OBJPROP_CORNER, 0);
      ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[j], OBJPROP_XDISTANCE, xpos);
      ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[j], OBJPROP_YDISTANCE, 70 + i * 30);
      xpos+=xstep;
   }
   return;
}


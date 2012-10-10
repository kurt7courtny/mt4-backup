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

string Spreads[] = {"2.5"};

string Indicators[] = { "Currency", "Spread", "ATR Yd", "ATR St", "ATR Lg"};

int cpn,idn;
int Level = 15;

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
      for( int j = 0; j < idn; j++)
      {
         switch (j)
         {
            case 0:
               handle0(i);
               break;
            case 1:
               handle1(i);
               break;
            case 2:
               handle2(i);
               break;
            case 3:
               break;
            case 4:
               break;
            default:
            Print("Canot Handle " + idn);
            break;
         }
      }
      /*
      color objc;
      double iH = iHigh( CurrencyPairs[i], PERIOD_D1, 1);
      double iL = iLow( CurrencyPairs[i], PERIOD_D1, 1);
      double iC = iClose( CurrencyPairs[i], PERIOD_D1, 1);
      double iO = iOpen( CurrencyPairs[i], PERIOD_D1, 1);
      double iHL = iH - iL;
      double iCO = iC - iO;
      
      if( iHL == 0) {
         objc = Silver;
      }
      else {
         double v = iCO / iHL;
         if( v == 0) {
            objc = Silver;
         }
         else if( v > 0) {
            if( v > dp1) {
               objc = Lime;
            }
            else if( v > dp2) {
               objc = Green;
            }
            else {
               objc = YellowGreen;
            }
         }
         else {
            v = MathAbs(v);
            if( v > dp1) {
               objc = Red;
            }
            else if( v > dp2) {
               objc = Tomato;
            }
            else {
               objc = FireBrick;
            }
         }
      }
      v = iCO / iHL;
      ObjectCreate("KP"+i, OBJ_LABEL, WindowFind("KDAILY PERCENT"), 0, 0);
      ObjectSetText("KP"+i,CurrencyPairs[i] + "   DailyPercent : " + DoubleToStr( v, 5) + "  ATR : " + DoubleToStr( iATR( CurrencyPairs[i], PERIOD_D1, 14, 0) * 10000, 0),9, "Arial Bold", objc);
      ObjectSet("KP"+i, OBJPROP_CORNER, 0);
      ObjectSet("KP"+i, OBJPROP_XDISTANCE, 100 + i / 15 * 300);
      ObjectSet("KP"+i, OBJPROP_YDISTANCE, 3 + i % 15 * 30);
   }
   */
//----
   }
   return(0);
  }
//+------------------------------------------------------------------+

void handle0(int i)
{
   color cor;
   if( iClose(CurrencyPairs[i], PERIOD_D1, 1) > iOpen(CurrencyPairs[i], PERIOD_D1, 1))
      cor=Green;
   else
      cor=Red;
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[0], CurrencyPairs[i],9, "Arial Bold", cor);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_XDISTANCE, 100);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_YDISTANCE, 70 + i * 30);
   return;
}

void handle1(int i)
{
   string str="";
   if(i<ArraySize(Spreads))
      str=Spreads[i];
   else
      str="0";
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[1], str,9, "Arial Bold", DeepPink);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_XDISTANCE, 200);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_YDISTANCE, 70 + i * 30);
   return;
}

void handle2(int i)
{
   double p2 = iATR(CurrencyPairs[i], PERIOD_D1, 1, 1);
   double p3 = iATR(CurrencyPairs[i], PERIOD_D1, 5, 1);
   double p4 = iATR(CurrencyPairs[i], PERIOD_D1, 66, 1);
   
   
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[2], DoubleToStr( p2, 4),9, "Arial Bold", DeepPink);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_XDISTANCE, 300);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_YDISTANCE, 70 + i * 30);
  
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[3], DoubleToStr( p3, 4),9, "Arial Bold", DeepPink);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_XDISTANCE, 400);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_YDISTANCE, 70 + i * 30);

   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[4], DoubleToStr( p4, 4),9, "Arial Bold", DeepPink);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_XDISTANCE, 500);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_YDISTANCE, 70 + i * 30);
   return;
}
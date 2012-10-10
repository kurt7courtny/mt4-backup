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

extern double dp1 = 0.7;                         // (open - close) / (high - low)  
extern double dp2 = 0.5;

string CurrencyPairs[] = { "EURUSD", "GBPUSD", "AUDUSD", "USDCAD", "USDCHF", "NZDUSD",
                           "EURGBP", "EURAUD", "EURCAD", "EURCHF", "EURNZD", 
                           "GBPAUD", "GBPCAD", "GBPCHF",
                           "AUDCAD", "AUDCHF", "AUDNZD",
                           "CADCHF", //"NZDCAD",
                           //"NZDCHF",
                           "USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CADJPY", "CHFJPY"
                           
};
int cpn;
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
   IndicatorShortName("KDAILY PERCENT");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for( int i = 0; i < cpn; i++) {
      ObjectDelete( "KP"+i);
   }
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
   for( int i = 0; i < cpn; i++) {
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
//----
   return(0);
  }
//+------------------------------------------------------------------+
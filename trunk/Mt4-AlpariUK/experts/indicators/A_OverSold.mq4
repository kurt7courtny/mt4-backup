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

string Indicators[] = { "Currency", "Spread", "ATR Yd", "ATR St", "ATR Lg", "Ins Day", "OutsDay", "ADX   "};

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
            case 5:
               handle5(i);
               break;
            case 6:
               break;
            case 7:
               handle7(i);
               break;
            default:
            Print("Canot Handle " + idn);
            break;
         }
      }
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
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[0], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
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
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[1], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   return;
}

void handle2(int i)
{
   double p2 = iATR(CurrencyPairs[i], PERIOD_D1, 1, 1);
   double p3 = iATR(CurrencyPairs[i], PERIOD_D1, 5, 1);
   double p4 = iATR(CurrencyPairs[i], PERIOD_D1, 66, 1);
   
   color cor2, cor3, cor4;
   if(p2>p3)
      cor2=Green;
   else 
      cor2=Red;
      
   if(p3>p4)
   {
      cor3=Green;
      cor4=Red;
   }
   else
   {
      cor3=Red;
      cor4=Green;
   }
   
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[2], DoubleToStr( p2, 4),9, "Arial Bold", cor2);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[2], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
     
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[3], DoubleToStr( p3, 4),9, "Arial Bold", cor3);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[3], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[4], DoubleToStr( p4, 4),9, "Arial Bold", cor4);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[4], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   return;
}

void handle5(int i)
{
   // yesterday high low, the day before high low.
   double p50 = iHigh(CurrencyPairs[i], PERIOD_D1, 1);
   double p51 = iLow(CurrencyPairs[i], PERIOD_D1, 1);
   
   double p52 = iHigh(CurrencyPairs[i], PERIOD_D1, 2);
   double p53 = iLow(CurrencyPairs[i], PERIOD_D1, 2);
   
   string strinside, stroutside;
   color cor50, cor51;
   if( p50<p52 && p51>p53)
   {
      cor50=Green;
      strinside="Yes";
   }else
   {
      cor50=Red;
      strinside="Nop";
   }
   
   if( p50>p52 && p51<p53)
   {
      cor51=Green;
      stroutside="Yes";
   }else
   {
      cor51=Red;
      stroutside="Nop";
   }
   
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[5], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[5], strinside,9, "Arial Bold", cor50);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[5], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[5], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[5], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
      
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[6], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[6], stroutside,9, "Arial Bold", cor51);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[6], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[6], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[6], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   
   return;
}

void handle7(int i)
{
   color cor;
   double p70 = iADX(CurrencyPairs[i], PERIOD_D1, 14, PRICE_CLOSE, MODE_MAIN, 1);
   if( p70 > 30)
      cor=Green;
   else
      cor=Red;
   ObjectCreate("tv."+CurrencyPairs[i]+"."+Indicators[7], OBJ_LABEL, WindowFind("Total View"), 0, 0);   
   ObjectSetText("tv."+CurrencyPairs[i]+"."+Indicators[7], DoubleToStr( p70, 0),9, "Arial Bold", cor);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[7], OBJPROP_CORNER, 0);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[7], OBJPROP_XDISTANCE, xpos);
   ObjectSet("tv."+CurrencyPairs[i]+"."+Indicators[7], OBJPROP_YDISTANCE, 70 + i * 30);
   xpos+=xstep;
   
   return;
}



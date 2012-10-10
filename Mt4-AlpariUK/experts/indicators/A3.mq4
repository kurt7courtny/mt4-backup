//+------------------------------------------------------------------+
//|                                                   Stochastic.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window

//---- input parameters
extern int HPeriod=3;
extern int LPeriod=3;
extern int MaMethod=3;
extern bool balert=true;

string CurrencyPairs[] = { "EURUSD", "GBPUSD", "AUDUSD", "USDCAD", "USDCHF", "NZDUSD",
                           "EURGBP", "EURAUD", "EURCAD", "EURCHF", "EURNZD", 
                           "GBPAUD", "GBPCAD", "GBPCHF",
                           "AUDCAD", "AUDCHF", "AUDNZD",
                           "CADCHF", "NZDCAD",
                           "NZDCHF",
                           "USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CADJPY", "CHFJPY",
                           "XAUUSD", "XAGUSD"
                           };

double CurrencyPairsALimit[] = { 0.0003, 0.0003, 0.0003, 0.0003, 0.0003, 0.0003,
                                0.0003, 0.0003, 0.0003, 0.00015, 0.0003,
                                0.0003, 0.0003, 0.0003,
                                0.0003, 0.0003, 0.0003,
                                0.0003, 0.0003,
                                0.0003,
                                0.03, 0.03, 0.03, 0.03, 0.03, 0.03,
                                0.5, 0.03
                           };
int cpn;
int prevtime;
string short_name = "Cube Break";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   cpn = ArraySize(CurrencyPairs);
   short_name = "cube break";
   if( cpn != ArraySize( CurrencyPairsALimit))
      short_name=short_name+" config error !";
   IndicatorShortName(short_name);
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   

   for(i=0; i<cpn;i++)
   {
      if(iStdDev(CurrencyPairs[i], PERIOD_H4,HPeriod,0,MODE_LWMA,PRICE_HIGH,1) < CurrencyPairsALimit[i] && prevtime != iTime(CurrencyPairs[i], PERIOD_H4, 0))
      {
         Alert(CurrencyPairs[i], " ", iStdDev(CurrencyPairs[i], PERIOD_H4,HPeriod,0,MODE_LWMA,PRICE_HIGH,1)," Upper Alert! ");
         short_name=short_name+" "+CurrencyPairs[i]+" up ! \n";
      }
      if(iStdDev(CurrencyPairs[i], PERIOD_H4,LPeriod,0,MODE_LWMA,PRICE_LOW,1) < CurrencyPairsALimit[i] && prevtime != iTime(CurrencyPairs[i], PERIOD_H4, 0))
      {
         Alert(CurrencyPairs[i], " ", iStdDev(CurrencyPairs[i], PERIOD_H4,LPeriod,0,MODE_LWMA,PRICE_LOW,1), " Lower Alert! ");
         short_name=short_name+" "+CurrencyPairs[i]+" down ! \n";
      }
   }
   Comment("\n", "\n", short_name);
   /*ObjectDelete("cube");
   if (ObjectFind("cube")!= 0) {
      ObjectCreate("cube",OBJ_TEXT, 0,Time[0],High[0]);
      ObjectSet("cube", OBJPROP_CORNER, 1);
      ObjectSetText("cube", short_name);
      //ObjectCreate(short_name, 
   }*/
   
   prevtime=iTime(CurrencyPairs[i], PERIOD_H4, 0);
   return (0);
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
   {
      //HighesBuffer[i]=iStdDev(NULL, NULL,HPeriod,0,MODE_LWMA,PRICE_HIGH,i);
      //LowesBuffer[i]=iStdDev(NULL, NULL,LPeriod,0,MODE_LWMA,PRICE_LOW,i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
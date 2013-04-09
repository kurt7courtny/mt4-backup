//+------------------------------------------------------------------+
//| BPA - D1 London Session.mq4.mq4
//| ? Ricky.Ricx @ BrooksPriceAction.com
//| http://www.brookspriceaction.com/
//+------------------------------------------------------------------+
#property copyright "? Ricky.Ricx @ BrooksPriceAction.com"
#property link      "http://www.brookspriceaction.com"

#property indicator_chart_window

double  London_Open=7;
double  USA_Close=18; //since this use M5 data to find OHLC D1 candle so london close is 11:55 is the same as 12:00

int init()
  {
   return(0);
  }

int deinit()
  {
   int      totalobjects;
   totalobjects=ObjectsTotal();

   ObjectsDeleteAll();
   return(0);
  }

int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- 
   for(i=0; i<limit; i++)
   {
      drawcandle(i);   
   }
  }

void drawcandle(int n)
{
   if( TimeHour(Time[n]) < London_Open || TimeHour(Time[n]) > USA_Close)
      return;
   //Print("timehour:", TimeHour(Time[n]));
   string candledatestr=TimeToStr( Time[n]);
   double openprice=Open[n];
   double closeprice=Close[n];
   double candledate=Time[n];
   double highestprice=High[n];
   double lowestprice=Low[n];
   
   if(ObjectFind(candledatestr+" candlebody")==-1) ObjectCreate(candledatestr+" candlebody", OBJ_TREND, 0, 0, 0);
   ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE1, openprice);
   ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE2, closeprice);
   ObjectSet(candledatestr+" candlebody", OBJPROP_TIME1, candledate);
   ObjectSet(candledatestr+" candlebody", OBJPROP_TIME2, candledate);
   ObjectSet(candledatestr+" candlebody", OBJPROP_RAY, false);
   ObjectSet(candledatestr+" candlebody", OBJPROP_BACK, true);
   ObjectSet(candledatestr+" candlebody", OBJPROP_WIDTH, 5);
   ObjectSet(candledatestr+" candlebody", OBJPROP_COLOR, Red);

   //plot bull candle body
   if(openprice<closeprice)
   {
      //if(ObjectFind(candledatestr+" bull candlebody")==-1) ObjectCreate(candledatestr+" bull candlebody", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" candlebody", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" candlebody", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" candlebody", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" candlebody", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" candlebody", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" candlebody", OBJPROP_COLOR, Green);
   }

   //plot candle shadows
   if(ObjectFind(candledatestr+" candleshadow")==-1) ObjectCreate(candledatestr+" candleshadow", OBJ_TREND, 0, 0, 0);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_PRICE1, highestprice);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_PRICE2, lowestprice);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_TIME1, candledate);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_TIME2, candledate);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_RAY, false);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_BACK, true);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_WIDTH, 1);
   ObjectSet(candledatestr+" candleshadow", OBJPROP_COLOR, Black);
   return;
}


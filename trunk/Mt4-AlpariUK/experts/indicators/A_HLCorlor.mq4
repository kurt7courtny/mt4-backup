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
   //Print("timehour:", TimeHour(Time[n]));
   string candledatestr=TimeToStr( Time[n]);
   double openprice=Open[n];
   double closeprice=Close[n];
   double candledate=Time[n];
   double highestprice=High[n];
   double highestpricey=High[n+1];
   double lowestprice=Low[n];
   double lowestpricey=Low[n+1];
   
   
   if(openprice>closeprice && lowestprice<lowestpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_BACK, true);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, Red);
   }

   //plot bull candle body
   if(openprice<closeprice && highestprice>highestpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, Green);
   }
   return;
}


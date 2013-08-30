//+------------------------------------------------------------------+
//| BPA - D1 London Session.mq4.mq4
//| ? Ricky.Ricx @ BrooksPriceAction.com
//| http://www.brookspriceaction.com/
//+------------------------------------------------------------------+
#property copyright "? Ricky.Ricx @ BrooksPriceAction.com"
#property link      "http://www.brookspriceaction.com"

#property indicator_chart_window

#define cor1 Lime
#define cor2 Yellow
#define cor3 Red
#define cor4 Green

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
   double candledate=Time[n];
   
   double openprice=Open[n];
   double openpricey=Open[n+1];
   double closeprice=Close[n];
   double closepricey=Close[n+1];
   double highestprice=High[n];
   double highestpricey=High[n+1];
   double lowestprice=Low[n];
   double lowestpricey=Low[n+1];
   
   /*
      STICKLINE(H>REF(H,1) AND C>REF(C,1) AND C>REF(O,1),CLOSE,OPEN,4,0),COLORFF00FF;
   */
   if( highestprice>highestpricey && closeprice>closepricey && closeprice>openpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, cor1);
      return;
   }
   
   //      STICKLINE(L<REF(L,1) AND C<REF(C,1) AND C<REF(O,1),CLOSE,OPEN,4,0),COLOR00FF00;
   if( lowestprice<lowestpricey && closeprice<closepricey && closeprice<openpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_BACK, true);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, cor2);
      return;
   }

   //      STICKLINE(C>REF(C,1) AND C>REF(O,1) AND O<REF(C,1) AND O<REF(O,1),C,O,4,0),COLORRED;   
   if( closeprice>closepricey && closeprice<openpricey && openprice<closepricey && openprice<openpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_BACK, true);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, cor3);
      return;
   }
   
   //      STICKLINE(C<REF(C,1) AND C<REF(O,1) AND O>REF(C,1) AND O>REF(O,1),C,O,4,0),COLOR000000;
   if( closeprice<closepricey && closeprice<openpricey && openprice<closepricey && openprice>openpricey)
   {
      if(ObjectFind(candledatestr+" hlc")==-1) ObjectCreate(candledatestr+" hlc", OBJ_TREND, 0, 0, 0);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE1, openprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_PRICE2, closeprice);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME1, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_TIME2, candledate);
      ObjectSet(candledatestr+" hlc", OBJPROP_RAY, false);
      ObjectSet(candledatestr+" hlc", OBJPROP_BACK, true);
      ObjectSet(candledatestr+" hlc", OBJPROP_WIDTH, 5);
      ObjectSet(candledatestr+" hlc", OBJPROP_COLOR, cor4);
      return;
   }
   
   if(ObjectFind(candledatestr+" hlc")!=-1) ObjectDelete(candledatestr+" hlc");
   return;
}


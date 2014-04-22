//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Average sample expert advisor"

#define MAGICMA  20140421
//--- Inputs
input double Lots          =0.1;
input double MaximumRisk   =0.02;
input double DecreaseFactor=3;
input int    ma  =10;
input int    tp  =500;
input int    sl  =200;

int lastime=0;
//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//--- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
  }
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//--- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
            continue;
         //---
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1)
         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//--- return lot size
   if(lot<Lots) lot=Lots;
   return(lot);
  }
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double pp;
   int    res;
   bool trend;
//--- go trading only for first tiks of new bar
   if(Volume[0]>1||lastime==iTime(NULL, PERIOD_D1,0)) return;
   trend=Close[1] < iMA( NULL, PERIOD_D1, ma, 1, MODE_SMA, PRICE_CLOSE, 0);
   if( iHigh(NULL, PERIOD_D1, 1) > iHigh(NULL, PERIOD_D1, 2) && iLow(NULL, PERIOD_D1, 1) > iLow(NULL, PERIOD_D1, 2))
   {
      pp = iLow(NULL, PERIOD_D1, 1);
      res=OrderSend(Symbol(),OP_SELLSTOP,LotsOptimized(), pp,3, pp+(iHigh(NULL, PERIOD_D1, 1)-iLow(NULL, PERIOD_D1, 1))/2, pp-tp*Point,"",MAGICMA,TimeCurrent()+PERIOD_D1*60,Red);
      lastime=iTime(NULL, PERIOD_D1,0);
      return;
   }
   
   if( iHigh(NULL, PERIOD_D1, 1) < iHigh(NULL, PERIOD_D1, 2) && iLow(NULL, PERIOD_D1, 1) < iLow(NULL, PERIOD_D1, 2))
   {
      pp = iHigh(NULL, PERIOD_D1, 1);
      res=OrderSend(Symbol(),OP_BUYSTOP,LotsOptimized(), pp,3, pp-(iHigh(NULL, PERIOD_D1, 1)-iLow(NULL, PERIOD_D1, 1))/2, pp+tp*Point,"",MAGICMA,TimeCurrent()+PERIOD_D1*60,Blue);
      lastime=iTime(NULL, PERIOD_D1,0);
      return;
   }
   return;
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {
   return;
   //---
  }
//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;
//--- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();
   else                                    CheckForClose();
//---
  }
//+------------------------------------------------------------------+

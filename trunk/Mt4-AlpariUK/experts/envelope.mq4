//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                      Copyright ?2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#define MAGICMA  20130410

extern double Lots               = 0.1;
extern double MaximumRisk        = 0.02;
extern double DecreaseFactor     = 3;
extern int p1=19;
extern int p2=20;


double lastopentime=0;
//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//---- return orders volume
   return (buys+sells);
   if(buys>0) return(buys);
   else       return(-sells);
  }
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   return(0.1);
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1) lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//---- return lot size
   if(lot<0.1) lot=0.1;
   return(lot);
  }
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double mah,mal,avgrange=0;
   int    res;
   bool buy=true, sell=true;
   
//---- go trading only for first tiks of new bar
//   if(Volume[0]>1) return;
//---- get Moving Average 
   //int tt=TimeHour(Time[0]);
   //if( tt <5||tt>18)return;
   if(lastopentime==Time[0])return;
   if(iClose(NULL, PERIOD_D1, 0)>iMA(NULL,PERIOD_D1,p1,0,MODE_EMA,PRICE_CLOSE,1))
   {
      if(Close[0]>iEnvelopes(NULL, 0, p2, MODE_EMA, 1, PRICE_CLOSE,0.2,MODE_UPPER,0))
      {
         res=OrderSend(Symbol(),OP_BUY,LotsOptimized(),Ask,3,Ask-250*Point,0,"",MAGICMA,0,Blue);
         lastopentime=Time[0];
         return;
      }
   }
   else
   {
      if(Close[0]<iEnvelopes(NULL, 0, p2, MODE_EMA, 1, PRICE_CLOSE,0.2,MODE_LOWER,0))  
      {
         res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,Bid+250*Point,0,"",MAGICMA,0,Red);
         lastopentime=Time[0];       
         return;
      }
   }
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
bool CheckForClose()
  {
   double ma1,mah,mal;
//---- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;
//---- get Moving Average 
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      ma1=iMA(NULL,0,p2,0,MODE_EMA,PRICE_CLOSE,1);
      mah=iHigh(NULL, PERIOD_D1, iHighest(NULL,PERIOD_D1,MODE_HIGH, 2, 1));
      mal=iLow(NULL, PERIOD_D1, iLowest(NULL,PERIOD_D1,MODE_LOW, 2, 1));
      //---- check order type 
      if(OrderType()==OP_BUY)
        {
         if(Close[0]<mal) 
         {OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         return(true);
         }
        }
      if(OrderType()==OP_SELL)
        {
         if(Close[0]>mah) 
         {OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         return(true);
         }
        }
     }
   return(false);
//----
  }
//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
  {
//---- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false) return;
//---- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())<1) CheckForOpen();
   CheckForClose();
//----
  }
//+------------------------------------------------------------------+
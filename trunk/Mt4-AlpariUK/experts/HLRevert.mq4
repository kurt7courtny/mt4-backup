//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                      Copyright ?2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#define MAGICMA  20130410

extern double Lots               = 0.1;
extern double MaximumRisk        = 0.02;
extern double DecreaseFactor     = 3;
extern int HLPeriod              = 10;
extern int pp                    = 50;              // point of over

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
   double hb,lb,hy,ly;
   int    res;
   
//---- go trading only for first tiks of new bar
//   if(Volume[0]>1) return;
//---- get Moving Average 
   //int tt=TimeHour(Time[0]);
   //if( tt <5||tt>18)return;
   if(lastopentime==iTime(NULL, PERIOD_D1,0))return;
   hb=iHigh(NULL, PERIOD_D1, iHighest(NULL,PERIOD_D1,MODE_HIGH, HLPeriod, 2));
   hy=iHigh( NULL, PERIOD_D1, 1);
   lb=iLow( NULL, PERIOD_D1, iLowest( NULL,PERIOD_D1,MODE_LOW , HLPeriod, 2));
   ly=iLow( NULL, PERIOD_D1, 1);
   
   if( hy > hb && hb!= iHigh( NULL, PERIOD_D1, 2))
   {
      res=OrderSend(Symbol(),OP_SELLSTOP,LotsOptimized(), hb-Point*pp,3, hy, ly, "",MAGICMA, iTime(NULL, PERIOD_D1,0)+86400,Red);
      //return;
   }
   
   if( ly < lb && lb!= iLow( NULL, PERIOD_D1, 2))
   {
      res=OrderSend(Symbol(),OP_BUYSTOP,LotsOptimized(), lb+Point*pp,3, ly, hy, "",MAGICMA, iTime(NULL, PERIOD_D1,0)+86400,Blue);
      //return;   
   }
   lastopentime=iTime(NULL, PERIOD_D1,0);
   Print("hb:"+hb+" hy:"+hy+" lb:"+lb+" ly:"+ly);
//----
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
bool CheckForClose()
  {
   double mah,mal;
//---- go trading only for first tiks of new bar
   //if(Volume[0]>1) return;
//---- get Moving Average 
   mah=MathMax(High[1], High[2]);
   mal=MathMin(Low[1], Low[2]);
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
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
   if(CalculateCurrentOrders(Symbol())<3) CheckForOpen();
   //while(CheckForClose())
   {
   }
//----
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#define MAGICMA  20310106

extern double Lots               = 0.1;
extern double MaximumRisk        = 0.02;
extern double DecreaseFactor     = 3;
extern double Maxlots            = 6;

extern double Trendline = 24;        // Ç÷ÊÆ¿ªÊ¼, ×¼±¸½ø³¡
extern double Period1 = PERIOD_H4;  // ´óÖÜÆÚÅÐ¶ÏÇ÷ÊÆ

extern double Waveline = 6;         // Ç÷ÊÆ½áÊø£¬Õðµ´¿ªÊ¼£¬wl < tl£¬ÍË³ö
extern double MA       = 20;        // ´©Ô½¾ùÏß½ø³¡
extern double fixsl  = 500;         // ¹Ì¶¨Ö¹Ëðµã

double lastime = 0;                 // last trade time
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
   if(buys>0) return(buys);
   else       return(sells);
  }
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
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
int trend=0;
void CheckForOpen()
  {
   int res;
   double ma=iMA(NULL, NULL, MA, 0, MODE_EMA, PRICE_CLOSE, 2);
   
   // ¶àÍ·
   if(trend>0)
   {
      if( Open[1]<=ma && Close[1]>=ma)   
      {
         res=OrderSend(Symbol(),OP_BUY,LotsOptimized(),Ask,3, Low[1],0,"",MAGICMA,0,Blue);
         lastime = Time[0];
         return;
      }
   }
   else if( trend < 0)
   {
      if( Open[1]>=ma && Close[1]<=ma)     
      {
         res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,High[1],0,"",MAGICMA,0,Red);
         lastime = Time[0];
         return;   
      }
   }
   return;
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {
     // -1 trend down, 1 trend up, 0 Ranging

      if( Open[0] > iHigh(NULL, Period1, iHighest(NULL, Period1, MODE_HIGH, Trendline, 1)))
      {
         trend=1;
      }
      else if( Open[0] < iLow(NULL, Period1, iLowest(NULL, Period1, MODE_LOW, Trendline, 1)))
      {
         trend=-1;
      }
      if( (Open[0] <= iLow(NULL, Period1, iLowest(NULL, Period1, MODE_LOW, Waveline, 1)) && trend > 0) || (Open[0] >= iHigh(NULL, Period1, iHighest(NULL, Period1, MODE_HIGH, Waveline, 1)) && trend < 0))
      {
         trend=0;
      }
      
      for(int i=0;i<OrdersTotal();i++)
      {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
       if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
       //---- check order type 
       if(OrderType()==OP_BUY )
         {
          if(trend<=0)
          {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
            break;
          }
         }
       if(OrderType()==OP_SELL)
         {
          if(trend>=0)
          {
            OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
            break;
          }
         }
      } 
  }
//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
  {
//---- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false) return;
//---- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())< Maxlots && lastime != Time[0]) CheckForOpen();
   CheckForClose();
//----
  }
//+------------------------------------------------------------------+
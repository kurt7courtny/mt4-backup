//+------------------------------------------------------------------+
//|                    Ninja Tutle - System2 - (fixed lots) Beta.mq4 |
//|                             Copyright © 2006, Mikhail Veneracion |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Mikhail Veneracion"
#property link      ""

extern double
         Lots                 = 0.1;   // Assign Fixed Lot Size to be traded,AutoLotSize must be false

extern int
         MaxUnits             = 3,     //Maximum units to trade per Currency Pair
         MagicNumber          = 11282,
         EntryLookBack        = 55,    //Bars to lookback in calculating breakout prices
         ExitLookBack         = 20,    //Bars to lookback in calculating exit points
         ATRPeriod            = 20;
extern double         
         SLMultiple           = 2.5,   //Multiply ATR by this to calculate StopLoss
         ReEntryMultiple      = 0.5;   //Multiple ATR by this to calculate Re Entry Point
extern bool
         ATRBreakEven         = false;  //if set to true SL will be moved to break even level
extern double         
         BreakEvenMultiple    = 2.5;
extern bool
         LockProfit           = true;
extern double
         PipLockinStart       = 50,   //$ amount to start lock in
         LockinPercent        = 30; 

//-------------------GLOBAL VARS
bool
         Revenge              = false; 
double
         RevengeSL            = 3;              


static int 
         TimeFrame;


double   LastEMAX,
         LastEMIN,
         LastXMAX,
         LastXMIN,
         LastOpen,
         PTLocked,
         PTPercent,
         spread,
         tickvalue,
         LastSL;
double
         EMAX,
         EMIN,
         trueEMAX,
         trueEMIN,
         XMAX,
         N,
         XMIN;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
         
int init()
  {

//----------------------- GENERATE MAGIC NUMBER AND TICKET COMMENT
//----------------------- SOURCE : PENGIE
   MagicNumber    = subGenerateMagicNumber(MagicNumber, Symbol(), Period());
   tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   subPrintDetails();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {

//----------------------- PREVENT RE-COUNTING WHILE USER CHANGING TIME FRAME
//----------------------- SOURCE : CODERSGURU
   TimeFrame=Period(); 
   return(0);

   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//-----------------SET VARIABLE VALUES
   int Ehighest_bar=Highest(NULL, 0, MODE_HIGH, EntryLookBack, 1);
   EMAX=NormalizeDouble (iHigh(NULL, 0, Ehighest_bar),Digits);

   int Elowest_bar=Lowest(NULL, 0, MODE_LOW, EntryLookBack, 1);
   EMIN=NormalizeDouble (iLow(NULL, 0, Elowest_bar),Digits);

   int Xhighest_bar=Highest(NULL, 0, MODE_HIGH, ExitLookBack, 1);
   XMAX=NormalizeDouble (iHigh(NULL, 0, Xhighest_bar),Digits);

   int Xlowest_bar=Lowest(NULL, 0, MODE_LOW, ExitLookBack, 1);
   XMIN=NormalizeDouble (iLow(NULL, 0, Xlowest_bar),Digits);
   
   N = NormalizeDouble ((iATR(NULL,0,20,1)),Digits);
   LastOpen = subLastOpenPrice();
   LastSL = subLastSLPrice();
   tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   subPrintDetails();
   spread = MarketInfo(Symbol(),MODE_SPREAD);
   
  // Unit=(AccountBalance()/100/N/Point*MarketInfo(Symbol(),MODE_TICKVALUE));
   double BStopLossLevel, SStopLossLevel;
	int BuyStopOrder = 0, SellStopOrder = 0, BuyOrder = 0, SellOrder = 0;
	int _GetLastError = 0, _OrdersTotal = OrdersTotal();
   double NSL = NormalizeDouble( N*RevengeSL, Digits );
	
//-----------------TRAILING TOTAL PROFITS WITH REVENGE
if(LockProfit)
   {
     
      PTPercent = NormalizeDouble(subPipProfitTotal()*(LockinPercent/100),0);
      
      if(subPipProfitTotal()>PipLockinStart)
      {
         if(PTPercent>PTLocked)
         {
            PTLocked = PTPercent;
         }
      }
      if(!Revenge)
      {  
         if(PTLocked>0)
         {
            if(PTLocked>=subPipProfitTotal())
            {
               subCloseOrder();
               PTLocked = 0;
            }
         }
      }
      if(Revenge)
      {
         if(subOrderType()==OP_SELL){
            if(PTLocked>0){ 
             if(PTLocked>=subPipProfitTotal())
               {
                  subCloseOrder();
                  PTLocked = 0;
                  if(OrderSend(Symbol(),OP_BUY,Lots,Ask,3,OrderOpenPrice()-NSL,0,"DocSniper EA",MagicNumber,0,Green)<0)
                        {
                            Print( "OrderOpen Error #", GetLastError() );
								    return(-1);
                        }
               }
            }   
         }
         if(subOrderType()==OP_BUY){
            if(PTLocked>0){ 
             if(PTLocked>=subPipProfitTotal())
               {
                  subCloseOrder();
                  PTLocked = 0;
                 if(OrderSend(Symbol(),OP_SELL,Lots,Bid,3,OrderOpenPrice()+NSL,0,"DocSniper EA",MagicNumber,0,Green)<0)
                        {
                            Print( "OrderOpen Error #", GetLastError() );
								    return(-1);
                        }
               }
            }   
         }
      }   
   }
   double Unit = Lots;
   
   
   

	
   for ( int z = _OrdersTotal - 1; z >= 0; z -- )
	{

		if ( !OrderSelect( z, SELECT_BY_POS ) )
		{
			_GetLastError = GetLastError();
			Print( "OrderSelect( ", z, ", SELECT_BY_POS ) - Error #", _GetLastError );
			continue;
		}


		if ( OrderSymbol() != Symbol() ) continue;


		if ( OrderMagicNumber() != MagicNumber ) continue;


		switch ( OrderType() )
		{
			case OP_BUY:		BuyOrder			= OrderTicket(); break;
			case OP_SELL:		SellOrder		= OrderTicket(); break;
			case OP_BUYSTOP:	BuyStopOrder	= OrderTicket(); break;
			case OP_SELLSTOP:	SellStopOrder	= OrderTicket(); break;
		}
	}
	
//-----------------------PENDING ORDERS PROCESS-----------------+

	if(subTotalOpenTrade()<1)
	{  PTLocked = 0;
	   LastXMIN = 0;
	   LastXMAX = 9999999; 
      BStopLossLevel = NormalizeDouble( EMAX - N*SLMultiple, Digits );
	  	SStopLossLevel = NormalizeDouble( EMIN + N*SLMultiple, Digits );
	  	double Spread = NormalizeDouble(spread*Point,Digits);
	  	string Modify1 = "none";
	  	string Modify2 = "none";  	
      trueEMAX = EMAX + Spread;
      trueEMIN = EMIN - Spread;
	  	
	  	  if((LastEMAX != trueEMAX)||(BuyStopOrder<1))
	  	  {
            if (BuyStopOrder>0)
            {
               int cnt;
               int total = subTotalBuyStopTrade();
               for(cnt=0;cnt<total;cnt++)
               {     
                  OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

                  if(OrderType()==OP_BUYSTOP && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                  {
                        
                        BuyStopOrder = OrderTicket();
                  }
                  OrderDelete(BuyStopOrder);
               }
               BuyStopOrder = 0;
            }
           
               
               
            if(subTotalBuyStopTrade()<1)
            {
               if (OrderSend(Symbol(),OP_BUYSTOP,Unit,trueEMAX,6,BStopLossLevel,0,"TURTLE POWER",MagicNumber,0,Green)<0)
               {
	           	    Print( "OrderSend Error #", GetLastError() );
		             return(-1);
	            }
               LastEMAX = trueEMAX;
               double BuyPrice = LastEMAX;            
            }
        }  
        if((LastEMIN != trueEMIN)||(SellStopOrder<1))
        {
            if (SellStopOrder>0)
            {
               total = subTotalSellStopTrade();
               for(cnt=0;cnt<total;cnt++)
               {     
                  OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

                  if(OrderType()==OP_SELLSTOP && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                  {
                        
                        SellStopOrder = OrderTicket();
                  }
                  OrderDelete(SellStopOrder);
               }
               SellStopOrder = 0;
            }
            if(subTotalSellStopTrade()<1)
            {
               if (OrderSend(Symbol(),OP_SELLSTOP,Unit,trueEMIN,6,SStopLossLevel,0,"TURTLE POWER",MagicNumber,0,Green)<0)
               {
	           	 Alert( "OrderSend Error #", GetLastError() );
		          return(-1);
	            }
               LastEMIN = trueEMIN;
               double SellPrice = LastEMIN; 
            }
        }
    }
   
//-----------------------------------------------------+   
//$$$$$$$$$$$$$$$$(OPEN BUY PROCESS)$$$$$$$$$$$$$$$$$$$+
//-----------------------------------------------------+
   if(BuyOrder>0)
   {  
      if (SellStopOrder>0)
      {
					if ( !OrderDelete( SellStopOrder ) )
					{
						Alert( "OrderDelete Error #", GetLastError() );
						return(-1);
					}
      }
      LastOpen = subLastOpenPrice();
      //-------------PENDING REENTRY PROCESS
      total = subTotalOpenTrade();
      if(total<MaxUnits)
      {
         double PendingTotal = subTotalBuyStopTrade();
         if(PendingTotal<1)
         {  
 
            BuyPrice = NormalizeDouble((LastOpen+N*ReEntryMultiple),Digits);
            double SL = NormalizeDouble(BuyPrice - N*SLMultiple, Digits );
            if(BuyPrice>Bid){
               if (OrderSend(Symbol(),OP_BUYSTOP,Unit,BuyPrice,6,SL,0,"TURTLE POWER",MagicNumber,0,Green)<0)
               {
	           	      Print( BuyPrice+"OrderSend Error #", GetLastError() );
		                return(-1);
	             }
            LastOpen = subLastOpenPrice();
            }         
         }
      }
      //-----------MODIFY STOPS AFTER REENTRY
      LastOpen = subLastOpenPrice();
      if((total>1)&&(XMIN<LastOpen))
      {   LastOpen = subLastOpenPrice();
          BStopLossLevel = NormalizeDouble(LastOpen - N*SLMultiple, Digits );
          total = OrdersTotal();
          for(cnt=0;cnt<total;cnt++)
          {     
              OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

              if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {	
                  if ( BStopLossLevel > OrderStopLoss()|| OrderStopLoss() <= 0.0 )
                  {
                      if ( !OrderModify( OrderTicket(), OrderOpenPrice(), BStopLossLevel,OrderTakeProfit(), OrderExpiration() ) )
					       {
								Print( "OrderModify Error #", GetLastError() );
								return(-1);
					       }
					       return(0);
					   }
               }
           }          
      }
      LastOpen = subLastOpenPrice();
      //-----------BREAK EVEN AFTER PIPS PROCESS
      if((ATRBreakEven)&&(XMIN<LastOpen))
      {
         double BreakEvenPrice = NormalizeDouble(LastOpen + N*BreakEvenMultiple,Digits);
         if(Bid > BreakEvenPrice){
           for(cnt=0;cnt<total;cnt++)
          {     
              OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

              if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {   
                  if ( LastOpen > OrderStopLoss()|| OrderStopLoss() <= 0.0 )
                  {
                     if ( !OrderModify( OrderTicket(), OrderOpenPrice(), LastOpen,OrderTakeProfit(), OrderExpiration() ) )
					      {
							     	Print( "OrderModify Error #", GetLastError() );
							     	return(-1);
					      }
					   }
               }
           }
           Modify2="done";   
         }
      }
      //-----------TRAILING STOP PROCESS
      LastSL = subLastSLPrice();
      total = subTotalOpenTrade();
      if(total>1)
      {
          if(LastSL < XMIN)
          {
               total = OrdersTotal();
               for(cnt=0;cnt<total;cnt++)
               {     
                  OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

                  if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                  {
                     if ( !OrderModify( OrderTicket(), OrderOpenPrice(), XMIN,OrderTakeProfit(), OrderExpiration() ) )
							{
								Print( "OrderModify Error #", GetLastError() );
								return(-1);
							}
                  }
               }   
				LastSL = subLastSLPrice();
						
          }  
      }
      //+----------END OF TRAILING STOP PROCESS
   }
//-----------------------------------------------------+   
//$$$$$$$$$$$$$$$(OPEN SELL PROCESS)$$$$$$$$$$$$$$$$$$$+
//-----------------------------------------------------+
   if(SellOrder>0)
   {
     if (BuyStopOrder>0)
     {
					if ( !OrderDelete( BuyStopOrder ) )
					{
						Alert( "OrderDelete Error #", GetLastError() );
						return(-1);
					}
      }
       LastOpen = subLastOpenPrice();
      //-------------PENDING REENTRY PROCESS
      total = subTotalOpenTrade();
      if(total<MaxUnits)
      {
         PendingTotal = subTotalSellStopTrade();
         if(PendingTotal<1)
         {  
 
            SellPrice = NormalizeDouble((LastOpen-N*ReEntryMultiple),Digits);
            SL = NormalizeDouble(SellPrice + N*SLMultiple, Digits );
            
            if(SellPrice<Bid){
               if (OrderSend(Symbol(),OP_SELLSTOP,Unit,SellPrice,6,SL,0,"TURTLE POWER",MagicNumber,0,Green)<0)
               {
	           	      Print( BuyPrice+"OrderSend Error #", GetLastError() );
		                return(-1);
	            }
            LastOpen = subLastOpenPrice();
            }        
         }
      }
      //-----------MODIFY STOPS AFTER REENTRY
      LastOpen = subLastOpenPrice();
      if((total>1)&&(XMAX>LastOpen))
      {   
         SStopLossLevel = NormalizeDouble(LastOpen + N*SLMultiple, Digits );
          total = OrdersTotal();
          for(cnt=0;cnt<total;cnt++)
          {     
              OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

              if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {	
                  if ( SStopLossLevel < OrderStopLoss()|| OrderStopLoss() <= 0.0 )
                  {
                      if ( !OrderModify( OrderTicket(), OrderOpenPrice(), SStopLossLevel,OrderTakeProfit(), OrderExpiration() ) )
					       {
								Print( "OrderModify Error #", GetLastError() );
								return(-1);
					       }
					       return(0);
					   }
               }
           }          
      }

      //-----------BREAK EVEN AFTER PIPS PROCESS
      LastOpen = subLastOpenPrice();
      if((ATRBreakEven)&&(XMAX>LastOpen)&&(total==MaxUnits))
      {  total = OrdersTotal();
         BreakEvenPrice = NormalizeDouble(LastOpen - N*BreakEvenMultiple,Digits);
         if(Bid < BreakEvenPrice){
           for(cnt=0;cnt<total;cnt++)
          {     
              OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

              if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
              {   
                  if ( LastOpen < OrderStopLoss()|| OrderStopLoss() <= 0.0 )
                  {
                     if ( !OrderModify( OrderTicket(), OrderOpenPrice(), LastOpen,OrderTakeProfit(), OrderExpiration() ) )
					      {
							     	Print( "OrderModify Error #", GetLastError() );
							     	return(-1);
					      }
					   }
               }
           }
         }
      }
      //-----------TRAILING STOP PROCESS
      LastSL = subLastSLPrice();
      if(XMAX<=LastOpen)
      {
          if(LastSL > XMAX)
          {
               total = OrdersTotal();
               for(cnt=0;cnt<total;cnt++)
               {     
                  OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

                  if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
                  {
                     if ( !OrderModify( OrderTicket(), OrderOpenPrice(), XMAX,OrderTakeProfit(), OrderExpiration() ) )
							{
								Print( "OrderModify Error #", GetLastError() );
								return(-1);
							}
                  }
               }   
				LastSL = subLastSLPrice();
						
          }  
      }
      //+----------END OF TRAILING STOP PROCESS
   }
  
     
//----
   return(0);
}
//+--------------------------END OF PROGRAM--------------------------+


//----------------------- GENERATE MAGIC NUMBER BASE ON SYMBOL AND TIME FRAME FUNCTION
//----------------------- SOURCE   : PENGIE

int subGenerateMagicNumber(int MagicNumber, string symbol, int timeFrame)
{
   int isymbol = 0;
   if (symbol == "EURUSD")       isymbol = 1;
   else if (symbol == "GBPUSD")  isymbol = 2;
   else if (symbol == "USDJPY")  isymbol = 3;
   else if (symbol == "USDCHF")  isymbol = 4;
   else if (symbol == "AUDUSD")  isymbol = 5;
   else if (symbol == "USDCAD")  isymbol = 6;
   else if (symbol == "EURGBP")  isymbol = 7;
   else if (symbol == "EURJPY")  isymbol = 8;
   else if (symbol == "EURCHF")  isymbol = 9;
   else if (symbol == "EURAUD")  isymbol = 10;
   else if (symbol == "EURCAD")  isymbol = 11;
   else if (symbol == "GBPUSD")  isymbol = 12;
   else if (symbol == "GBPJPY")  isymbol = 13;
   else if (symbol == "GBPCHF")  isymbol = 14;
   else if (symbol == "GBPAUD")  isymbol = 15;
   else if (symbol == "GBPCAD")  isymbol = 16;
   else                          isymbol = 17;
   if(isymbol<10) MagicNumber = MagicNumber * 10;
   return (StrToInteger(StringConcatenate(MagicNumber, isymbol, timeFrame)));
   
}
//----------------------- PRINT COMMENT FUNCTION
//----------------------- SOURCE : CODERSGURU
void subPrintDetails()
{
   string sComment   = "";
   string sp         = "-------------------------------------------------------------\n";
   string NL         = "\n";

   sComment = sp;

   sComment = sComment + sp;
   sComment = sComment + "BULL ENTRY= " + DoubleToStr(EMAX,4) + " | ";
   sComment = sComment + "BULL EXIT= " + DoubleToStr(XMIN,4) + " | ";
   sComment = sComment + NL; 
   sComment = sComment + sp;
   sComment = sComment + "BEAR ENTRY= " + DoubleToStr(EMIN,4) + " | ";
   sComment = sComment + "BEAR EXIT= " + DoubleToStr(XMAX,4) + " | ";
   sComment = sComment + NL; 
   sComment = sComment + sp;
   sComment = sComment + "ATR =" + DoubleToStr(N,4) + " | ";
   sComment = sComment + "Spread =" + DoubleToStr(spread,4) + " | ";
   sComment = sComment + "tickvalue =" + DoubleToStr(tickvalue,4) + " | ";
   sComment = sComment + NL; 
   sComment = sComment + sp;
   sComment = sComment + "Total Pips= " +DoubleToStr(subPipProfitTotal(),0) + " | ";
   sComment = sComment + "Pips Locked in= " + DoubleToStr(PTLocked,0) + " | ";
   sComment = sComment + "T.P.Percent =" + DoubleToStr(PTPercent,4) + " | ";
   sComment = sComment + NL; 
   sComment = sComment + sp;
   Comment(sComment);
}

//----------COUNT OPEN TRADES------------------+

int subTotalOpenTrade()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber) total++;
   }
   return(total);
}
//----------GET LASt OPENED PRICE------------------+

double subLastOpenPrice()
{
   int
      cnt, 
      total = 0;
   double OpenPrice;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
         
         OpenPrice = OrderOpenPrice();
         
   }
   return(OpenPrice);
}
//----------GET LASt SL PRICE------------------+

double subLastSLPrice()
{
   int
      cnt, 
      total = 0;
   double SLPrice;
   
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
         
         SLPrice = OrderStopLoss();
         
   }
   return(SLPrice);
}
//----------COUNT BUYSTOP ORDERS---------------+

int subTotalBuyStopTrade()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUYSTOP&&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber) total++;
   }
   return(total);
}
//-----------COUNT SELLSTOP ORDERS-------------+

int subTotalSellStopTrade()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_SELLSTOP&&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber) total++;
   }
   return(total);
}
//----------COUNT OPEN TRADES------------------+

double subPipProfitTotal()
{
   int
      cnt, 
      total = 0;
   tickvalue = MarketInfo(Symbol(),MODE_TICKVALUE);
   double TotalProfit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if((OrderType()==OP_SELL||OrderType()==OP_BUY) &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
         {
         double PipProfit = (OrderProfit()/OrderLots()/tickvalue);
         TotalProfit = TotalProfit+PipProfit;
         }
   }
   return(TotalProfit);
} 
//----------------------- CLOSE ORDER FUNCTION
//----------------------- SOURCE: FIREDAVE
void subCloseOrder()
{
   int
         cnt, 
         total       = 0,
         ticket      = 0,
         err         = 0,
         c           = 0;

   total = OrdersTotal();
   for(cnt=total-1;cnt>=0;cnt--)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);

      if(OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber)
      {
         switch(OrderType())
         {
            case OP_BUY      :
               for(c=0;c<10;c++)
               {
                  ticket=OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);
                  err=GetLastError();
                  if(err==0)
                  { 
                     if(ticket>0) break;
                  }
                  else
                  {
                     if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                     {
                        Sleep(5000);
                        continue;
                     }
                     else //normal error
                     {
                        if(ticket>0) break;
                     }  
                  }
               }   
               break;
               
            case OP_SELL     :
               for(c=0;c<10;c++)
               {
                  ticket=OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);
                  err=GetLastError();
                  if(err==0)
                  { 
                     if(ticket>0) break;
                  }
                  else
                  {
                     if(err==0 || err==4 || err==136 || err==137 || err==138 || err==146) //Busy errors
                     {
                        Sleep(5000);
                        continue;
                     }
                     else //normal error
                     {
                        if(ticket>0) break;
                     }  
                  }
               }   
               break;
               
            case OP_BUYLIMIT :
            case OP_BUYSTOP  :
            case OP_SELLLIMIT:
            case OP_SELLSTOP :
               OrderDelete(OrderTicket());
         }
      }
   }      
}
//----------GET ORDER TYPE
int subOrderType()
{
   int
      cnt, 
      total = 0;

   for(cnt=0;cnt<OrdersTotal();cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      total = OrderType();
   }
   return(total);
}
//+------------------------------------------------------------------+
//|                                                       kAlert.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#define T_UPPER    0           
#define T_LOWER    1           
#define T_UPEST    2           
#define T_LOWEST   3
#define T_OPEN     4
#define T_CLOSE    5

extern bool	EmailAlert1	= false;
extern bool	EmailAlert2	= true;
extern int  iPeriod = 5;
extern int  iMsgconf = 10;

double dparam = 0;
int ilastpoint;
int ipoint;
int icp=0;
int m45 = 13500, h4 = 14400;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   string sSymbol = Symbol();
   if( sSymbol == "EURUSD") {
      ipoint = 20;
      dparam = 10000;
   }
   else if( sSymbol == "GBPUSD") {
      ipoint = 20;
      dparam = 10000;
   }
   ilastpoint = Bid * dparam;
   ilastpoint = ilastpoint - ilastpoint % ipoint;
   
   if( iMsgconf < 10)
      iMsgconf = 10;
   string sTitle;
   sTitle = "启动监控报警：" + Symbol() + " 价位：" + DoubleToStr(Bid,Digits);
   if( EmailAlert1 && Bid !=0 )
      SendMail( sTitle, "");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int inowp;
   string sTitle, sMessage;
   inowp = Bid * dparam;
   if( ilastpoint - inowp > ipoint) {
      sTitle = Symbol() + " 价格：" + DoubleToStr(Bid,Digits)  +" 下降" + ipoint + "点．";
      sMessage = "";
      if( EmailAlert1)
         SendMail( sTitle, sMessage);
      ilastpoint = inowp - inowp % ipoint + ipoint;
   }
   else if( inowp - ilastpoint > ipoint) {
      sTitle = Symbol() + " 价格：" + DoubleToStr(Bid,Digits)  +" 上升" + ipoint + "点．";  
      sMessage = "";
      if( EmailAlert1)
         SendMail( sTitle, sMessage);
      ilastpoint = inowp - inowp % ipoint;
   }
   int itmp1 = 0, itmp2 = 0, itmp3 = 0;
   double dupper, dlower, dupest, dlowest, dprice, dtmp1, dtmp2;
   dupper = getintervals( Symbol(), T_UPPER, iPeriod);
   dlower = getintervals( Symbol(), T_LOWER, iPeriod);
   dupest = getintervals( Symbol(), T_UPEST, iPeriod);
   dlowest = getintervals( Symbol(), T_LOWEST, iPeriod);
   dprice = Close[0];
   dtmp1 = dupest;
   dtmp2 = (dupest - dlowest) / iMsgconf;
   sTitle = Symbol() + ":" + DoubleToStr(Bid,4) + "~" + DoubleToStr((dupest - dlowest) * dparam, 0);
   sMessage = "=========================(";
   //sMessage = "------------------------------------------";
   for( int i = 0; i < iMsgconf+1; i++)
   {
      double dp1 = dupest - i * dtmp2;
      //Print("dp1:" + dp1);
      if( dp1 < dtmp1)
         sMessage = sMessage + "-";
      
      if( dp1 < dupper)
      {
         dtmp1 = 0;  
         if( itmp1 == 0)
            sMessage = sMessage + "|";
         else
            sMessage = sMessage + "_";
         itmp1 += 1;
      }
      
      if( dp1 < dprice)
      {
         dupper = 0;
         if( itmp2 == 0)
            sMessage = sMessage + "|";
         else
            sMessage = sMessage + "_";
         itmp2 += 1;
      }
      
      if( dp1 < dlower)
      {
         dprice = 0;
         if( itmp3 == 0)
            sMessage = sMessage + "|";
         else
            sMessage = sMessage + "-";
         itmp3 += 1;
      }
      //Print("dp1:" + dp1 + " dupest:"+dtmp1+" dupper:"+ dupper + " dp:"+ dprice + " dlower:" + dlower + " dlowest:" + dlowest + " sMessage:", sMessage);
   }
   //Print("sMessage:", sMessage);
   sMessage = sMessage + ")===";
   /*
   dtmp1 = (dlower - dlowest) / ((dupest - dupper) + (dlower - dlowest));
   dtmp2 = (dprice - dlower) / (dupper - dlower);
   sTitle = Symbol() + " 区间";  
   sMessage = "当前价格：" + DoubleToStr( dprice, 4) 
   + "____价格区间：" + DoubleToStr( (dupper - dlower) * dparam, 0) + "---" + DoubleToStr( (dupest - dlowest) * dparam, 0) 
   + "________区间比例：" + DoubleToStr( dtmp1 * 100, 0) + "% ~ " + DoubleToStr( dtmp2 * 100, 0) + "%____";
   //DoubleToStr( dlowest, 4) + "　~　" + DoubleToStr( dupest, 4) + " , " + DoubleToStr( dlower, 4) + " - " + DoubleToStr( dupper, 4);
   */
   int now = iTime(NULL, PERIOD_M15, 0);
   //Print("now is ", sMessage);                           
   if( EmailAlert2 && m45 == MathMod( now, h4) && now != icp) 
   {
      SendMail( sTitle, sMessage);
      icp = now;  
   }
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

double getintervals( string sb, int type, int period)
{
   double resp = 0, upest=0, lowest=10000, upper = 0, lower=1000;
   if( period < 3)
      period = 3;
   for( int i = period - 1; i >= 0; i--)
   {
      upest = MathMax( upest, iHigh( sb, PERIOD_H1, i));
      lowest= MathMin( lowest, iLow( sb, PERIOD_H1, i));
      upper = MathMax( MathMax( iOpen( sb, PERIOD_H1, i), iClose( sb, PERIOD_H1, i)), upper);
      lower = MathMin( MathMin( iOpen( sb, PERIOD_H1, i), iClose( sb, PERIOD_H1, i)), lower);
   }
   switch( type)
   {
      case T_UPPER:
         resp = upper;
         break;
      case T_LOWER:
         resp = lower;
         break;
      case T_UPEST:
         resp = upest;
         break;
      case T_LOWEST:
         resp = lowest;
         break;
      case T_OPEN:
         resp = iOpen(sb, PERIOD_H1, period);
         break;
      case T_CLOSE:
         resp = iClose(sb, PERIOD_H1, 0);
         break;
      default:
         break;
   } 
   return (resp);
}
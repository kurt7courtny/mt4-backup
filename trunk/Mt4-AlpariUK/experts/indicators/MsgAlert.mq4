//+------------------------------------------------------------------+
//|                                                     MsgAlert.mq4 |
//|                                            Copyright ?2010, Kurt |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Kurt"
#property link      "http://www.metaquotes.net"


#property indicator_chart_window
#define			OBJNAME_LABEL		"Msg Label"
//---- input parameters
extern bool		EmailAlert	= true;
extern bool		PopupAlert	= true;
extern string  ServerName = "S188";

double dparam = 0;
int ilastpoint;
int  ipoint;
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
   // Print("ilastpoint ", ilastpoint);
   createIndicatorLabel(OBJNAME_LABEL);
   string sTitle, sMessage=ServerName;
   sTitle = Symbol() + "@" + DoubleToStr(Bid,Digits) +" @Start";
   if( EmailAlert)
      SendMail( sTitle, sMessage);
   if( PopupAlert) {
         Alert( "<Title> : " + sTitle );
         PlaySound("email.wav");
   }
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
   int    counted_bars=IndicatorCounted(), inowp;
   string sTitle, sMessage;
   inowp = Bid * dparam;
   if( ilastpoint - inowp > ipoint) {
      sTitle = Symbol() + "@" + DoubleToStr(Bid,Digits)  +" D.";
      sMessage = ServerName + " Alert triggered: " + Symbol() + "@" + DoubleToStr(Bid,Digits)  +"."
			+ "  get down " + ipoint + " pips from " + ilastpoint + ".";
      if( EmailAlert)
         SendMail( sTitle, sMessage);
      if( PopupAlert) {
         Alert( "<Title> : " + sTitle + " <Message> : " + sMessage);
         PlaySound("email.wav");
      }
      ilastpoint = inowp - inowp % ipoint + ipoint;
   }
   else if( inowp - ilastpoint > ipoint) {
      sTitle = Symbol() + "@" + DoubleToStr(Bid,Digits)  +" U.";  
      sMessage = ServerName + " Alert triggered: " + Symbol() + "@" + DoubleToStr(Bid,Digits)  +"."
			+ "  move up " + ipoint + " pips from " + ilastpoint + ".";
      if( EmailAlert)
         SendMail( sTitle, sMessage);
      if( PopupAlert) {
         Alert( "<Title> : " + sTitle + " <Message> : " + sMessage);
         PlaySound("email.wav");
      }
      ilastpoint = inowp - inowp % ipoint;
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void createIndicatorLabel(string sObjName) {
	
	// Set the text
	string sObjText = "Alerter:";
	if (EmailAlert) sObjText = sObjText + "  Emails Alerts ON.";
	else            sObjText = sObjText + "  Emails Alerts OFF.";
	if (PopupAlert) sObjText = sObjText + "  Popup Alerts ON.";
	else			sObjText = sObjText + "  Popup Alerts OFF.";
	
	// Create and position the label
	ObjectCreate(sObjName,OBJ_LABEL,0,0,0);
	ObjectSetText(sObjName,sObjText,8,"Arial",Yellow);
	ObjectSet(sObjName,OBJPROP_XDISTANCE,5);
	ObjectSet(sObjName,OBJPROP_YDISTANCE,5);
	ObjectSet(sObjName,OBJPROP_CORNER,1);
	
}
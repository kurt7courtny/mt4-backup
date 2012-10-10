#define			OBJNAME_LABEL		"Alerter Label"
#define			OBJDESC_PATTERN		"Alert_"

#property indicator_chart_window

extern bool		EmailAlert	= false;
extern bool		PopupAlert	= true;

extern int		iObjAlert = 20;

int lastalert = 0;

int init() {
	createIndicatorLabel(OBJNAME_LABEL);
}

int deinit() {
	ObjectDelete(OBJNAME_LABEL);
}

int start() {

	// Iterate over objects on this chart
	for (int i=ObjectsTotal()-1;i>=0;i--) {
		string	sObjName 	= ObjectName(i);
		double	dObjPrice;
		
		int		iProximity;
		string	sMessage;
		
		// Can we get a price for this object?  If not, continue iteration
		dObjPrice = getObjectPrice(sObjName);
		if (dObjPrice == -1) continue;
		
		// Is there an alert on this object?  If not, continue iteration
		// iObjAlert = getObjectAlert(sObjName);
		// if (iObjAlert == -1) continue;
		
		// Is the line within alert proximity?  If not, continue iteration
		iProximity = MathAbs(Bid - dObjPrice) / Point;
		if (iProximity > iObjAlert) continue;

		// Fire the alert and clear alert from description
		sMessage = "Alert triggered: " + Symbol() + "@" + DoubleToStr(Bid,Digits)  +"."
			+ "  " + iProximity + " pips from " + sObjName + ".";
		if (PopupAlert) Alert(sMessage);
		if (EmailAlert) SendMail("Alert on " + Symbol(), sMessage);
		lastalert = Time[0];
		// Clear the alert from the object description
		// clearObjectAlert(sObjName);
	}

	return(0);
}

double getObjectPrice(string sObjName) {

	int iObjType = ObjectType(sObjName);
	
	// if alerted
	if(lastalert == Time[0])
	  return(-1);
	
	// if it's a horizontal line...
	if (iObjType == OBJ_HLINE && StringFind(sObjName, "Horizontal Line") > -1)
		return(ObjectGet(sObjName,OBJPROP_PRICE1));
	
	// if it's a trend line...
	if (iObjType == OBJ_TREND && StringFind(sObjName, "Trendline") > -1)
		return(ObjectGetValueByShift(sObjName,0));
	
	// otherwise...
	return(-1);
}

/*
int getObjectAlert(string sObjName) {

	// looking for pattern "alert_##" at end of obj description
	string 	sObjectDesc		= ObjectDescription(sObjName);
	int 	iPatternOffset 	= StringFind(sObjectDesc,OBJDESC_PATTERN);
	int		iPatternLength	= StringLen(OBJDESC_PATTERN);

	// if pattern not found, no alert for this object
	if (iPatternOffset == -1) 
		return(-1);
	
	// return value after the pattern as number
	//Print("Alert: ", StringSubstr(sObjectDesc,iPatternOffset+iPatternLength));
	return(StrToInteger(StringSubstr(sObjectDesc,iPatternOffset+iPatternLength)));
}

void clearObjectAlert(string sObjName) {

	// strip "alert_*" from end of obj description
	string 	sObjDesc 		= ObjectDescription(sObjName);
	int 	iSubStrOffset 	= StringFind(sObjDesc,"Alert_");
	
	// if found at start of description, clear description
	if (iSubStrOffset == 0) {
		ObjectSetText(sObjName,"");
		return;
	}
	
	// if found further on in desc, strip it from description
	if (iSubStrOffset > 0) {
		ObjectSetText(sObjName,StringSubstr(sObjDesc,0,iSubStrOffset));
		return;
	}
}
*/

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
	


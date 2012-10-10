/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright ?2007, fxid10t@yahoo.com"
#property link      "www.ooida.com"

#property indicator_chart_window

int g_timeframe_76 = 0;
extern int iHour = 6;
int shift;
int g_color_84 = Fuchsia;
double gd_88;
double gd_96;
double gd_104;
double gd_112;
int gi_120;
int gi_124;
int gi_128;
int gi_132;
double gd_136;
double gd_144;
double gd_152;
double gd_160;
int gi_168;
int gi_172;
int gi_176;
int gi_180;

int init() {
   shift=iHour*60/Period();
   return (0);
}

int deinit() {
   if (UninitializeReason() != REASON_CHARTCHANGE) {
      for (int l_objs_total_0 = ObjectsTotal(); l_objs_total_0 >= 0; l_objs_total_0--)
         if (StringSubstr(ObjectName(l_objs_total_0), 0, 9) == "Old Lo TL" || StringSubstr(ObjectName(l_objs_total_0), 0, 9) == "Old Hi TL") ObjectDelete(ObjectName(l_objs_total_0));
   }
   ObjectDelete(g_timeframe_76 + " Lo TL");
   ObjectDelete(g_timeframe_76 + " Hi TL");
   ObjectsDeleteAll(0, OBJ_ARROW);
   return (0);
}

int start() {
   if (ObjectFind(g_timeframe_76 + " Lo TL") < 0) initial.temp.low.TL();
   if (ObjectFind(g_timeframe_76 + " Hi TL") < 0) initial.temp.high.TL();
   if (ObjectFind(g_timeframe_76 + " Lo TL") > -1) {
      if (gi_120 == 0) gi_120 = ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_TIME1);
      if (gd_88 == 0.0) gd_88 = ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_PRICE1);
      if (gi_124 == 0) gi_124 = ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_TIME2);
      if (gd_96 == 0.0) gd_96 = ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_PRICE2);
   }
   if (ObjectFind(g_timeframe_76 + " Hi TL") > -1) {
      if (gi_168 == 0) gi_168 = ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_TIME1);
      if (gd_136 == 0.0) gd_136 = ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_PRICE1);
      if (gi_172 == 0) gi_172 = ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_TIME2);
      if (gd_144 == 0.0) gd_144 = ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_PRICE2);
   }
   int l_shift_0 = iBarShift(Symbol(), g_timeframe_76, gi_120);
   for (int l_shift_4 = l_shift_0; l_shift_4 > l_shift_0; l_shift_4--) {
      if (iLow(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_RAY) == 1.0 && iLow(Symbol(), g_timeframe_76, l_shift_4) < ObjectGetValueByShift(g_timeframe_76 +
         " Lo TL", l_shift_4)) {
         gd_88 = iLow(Symbol(), g_timeframe_76, l_shift_4);
         gi_120 = Time[l_shift_4];
         if (iBarShift(Symbol(), g_timeframe_76, gi_120) - iBarShift(Symbol(), g_timeframe_76, gi_124) < 2) {
            gd_88 = gd_96;
            gi_120 = gi_124;
         }
         ObjectMove(g_timeframe_76 + " Lo TL", 0, gi_120, gd_88);
      }
   }
   int l_shift_8 = iBarShift(Symbol(), g_timeframe_76, gi_124);
   for (l_shift_4 = 2; l_shift_4 < l_shift_8; l_shift_4++) {
      if (iLow(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && ObjectGet(g_timeframe_76 + " Lo TL", OBJPROP_RAY) == 1.0 && iLow(Symbol(), g_timeframe_76, l_shift_4) < ObjectGetValueByShift(g_timeframe_76 +
         " Lo TL", l_shift_4)) {
         gd_96 = iLow(Symbol(), g_timeframe_76, l_shift_4);
         gi_124 = Time[l_shift_4];
         ObjectMove(g_timeframe_76 + " Lo TL", 1, gi_124, gd_96);
      }
   }
   if (gd_88 != Low[iBarShift(Symbol(), g_timeframe_76, gi_120)]) {
      gi_120 = Time[iBarShift(Symbol(), g_timeframe_76, gi_120) - 1];
      ObjectMove(g_timeframe_76 + " Lo TL", 0, gi_120, gd_88);
   }
   if (gd_96 != Low[iBarShift(Symbol(), g_timeframe_76, gi_124)]) {
      gi_124 = Time[iBarShift(Symbol(), g_timeframe_76, gi_124) - 1];
      ObjectMove(g_timeframe_76 + " Lo TL", 1, gi_124, gd_96);
   }
   int l_shift_12 = iBarShift(Symbol(), g_timeframe_76, gi_168);
   for (l_shift_4 = l_shift_12; l_shift_4 > l_shift_12; l_shift_4--) {
      if (iHigh(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_RAY) == 1.0 && iHigh(Symbol(), g_timeframe_76, l_shift_4) > ObjectGetValueByShift(g_timeframe_76 +
         " Hi TL", l_shift_4)) {
         gd_136 = iHigh(Symbol(), g_timeframe_76, l_shift_4);
         gi_168 = Time[l_shift_4];
         if (iBarShift(Symbol(), g_timeframe_76, gi_168) - iBarShift(Symbol(), g_timeframe_76, gi_172) < 2) {
            gd_136 = gd_144;
            gi_168 = gi_172;
         }
         ObjectMove(g_timeframe_76 + " Hi TL", 0, gi_168, gd_136);
      }
   }
   int l_shift_16 = iBarShift(Symbol(), g_timeframe_76, gi_172);
   for (l_shift_4 = 2; l_shift_4 < l_shift_16; l_shift_4++) {
      if (iHigh(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && ObjectGet(g_timeframe_76 + " Hi TL", OBJPROP_RAY) == 1.0 && iHigh(Symbol(), g_timeframe_76, l_shift_4) > ObjectGetValueByShift(g_timeframe_76 +
         " Hi TL", l_shift_4)) {
         gd_144 = iHigh(Symbol(), g_timeframe_76, l_shift_4);
         gi_172 = Time[l_shift_4];
         ObjectMove(g_timeframe_76 + " Hi TL", 1, gi_172, gd_144);
      }
   }
   if (gd_136 != High[iBarShift(Symbol(), g_timeframe_76, gi_168)]) {
      gi_168 = Time[iBarShift(Symbol(), g_timeframe_76, gi_168) - 1];
      ObjectMove(g_timeframe_76 + " Hi TL", 0, gi_168, gd_136);
   }
   if (gd_144 != High[iBarShift(Symbol(), g_timeframe_76, gi_172)]) {
      gi_172 = Time[iBarShift(Symbol(), g_timeframe_76, gi_172) - 1];
      ObjectMove(g_timeframe_76 + " Hi TL", 1, gi_172, gd_144);
   }
   if (iClose(Symbol(), g_timeframe_76, 1) > ObjectGetValueByShift(g_timeframe_76 + " Hi TL", 1)) {
      ObjectCreate("Old Hi TL " + iTime(Symbol(), g_timeframe_76, 1), OBJ_TREND, 0, gi_168, gd_136, Time[1], ObjectGetValueByShift(g_timeframe_76 + " Hi TL", 1));
      ObjectSet("Old Hi TL " + iTime(Symbol(), g_timeframe_76, 1), OBJPROP_RAY, FALSE);
   }
   if (iClose(Symbol(), g_timeframe_76, 1) < ObjectGetValueByShift(g_timeframe_76 + " Lo TL", 1)) {
      ObjectCreate("Old Lo TL " + iTime(Symbol(), g_timeframe_76, 1), OBJ_TREND, 0, gi_120, gd_88, Time[1], ObjectGetValueByShift(g_timeframe_76 + " Lo TL", 1));
      ObjectSet("Old Lo TL " + iTime(Symbol(), g_timeframe_76, 1), OBJPROP_RAY, FALSE);
   }
   if (gd_136 - gd_88 < gd_144 - gd_96) {
      gd_88 = gd_96;
      gd_96 = 0;
      gd_136 = gd_144;
      gd_144 = 0;
      initial.temp.high.TL();
      initial.temp.low.TL();
   }
   if (gi_124 == 0 && gd_96 < Low[iBarShift(Symbol(), g_timeframe_76, gi_124)]) ObjectDelete(g_timeframe_76 + " Lo TL");
   if (gi_168 == 0 && gi_172 == 0) ObjectDelete(g_timeframe_76 + " Hi TL");
   return (0);
}

void initial.temp.high.TL() {
   if (iHigh(Symbol(), g_timeframe_76, 0) < iHigh(Symbol(), g_timeframe_76, 1)) {
      gd_136 = iHigh(Symbol(), g_timeframe_76, 1);
      gi_168 = iTime(Symbol(), g_timeframe_76, 1);
   } else {
      gd_136 = iHigh(Symbol(), g_timeframe_76, 0);
      gi_168 = iTime(Symbol(), g_timeframe_76, 0);
   }
   gd_144 = iHigh(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_168) + 1);
   gi_172 = iTime(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_168) + 1);
   ObjectCreate(g_timeframe_76 + " Hi TL", OBJ_TREND, 0, gi_168, gd_136, gi_172, gd_144);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_COLOR, g_color_84);
   int l_shift_0 = iBarShift(Symbol(), g_timeframe_76, gi_172);
   for (int l_shift_4 = l_shift_0; l_shift_4 < l_shift_0 + shift; l_shift_4++) {
      if (iHigh(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && iHigh(Symbol(), g_timeframe_76, l_shift_4) > ObjectGetValueByShift(g_timeframe_76 + " Hi TL", l_shift_4)) {
         gd_144 = iHigh(Symbol(), g_timeframe_76, l_shift_4);
         gi_172 = Time[l_shift_4];
         ObjectMove(g_timeframe_76 + " Hi TL", 1, gi_172, gd_144);
      }
   }
   secondary.temp.high.TL();
}

void secondary.temp.high.TL() {
   gd_136 = gd_144;
   gi_168 = gi_172;
   gd_144 = iHigh(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_168) + 1);
   gi_172 = iTime(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_168) + 1);
   ObjectDelete(g_timeframe_76 + " Hi TL");
   ObjectCreate(g_timeframe_76 + " Hi TL", OBJ_TREND, 0, gi_168, gd_136, gi_172, gd_144);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_COLOR, g_color_84);
   int l_shift_0 = iBarShift(Symbol(), g_timeframe_76, gi_172);
   for (int l_shift_4 = l_shift_0; l_shift_4 < l_shift_0 + shift; l_shift_4++) {
      if (iHigh(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && iHigh(Symbol(), g_timeframe_76, l_shift_4) > ObjectGetValueByShift(g_timeframe_76 + " Hi TL", l_shift_4)) {
         gd_144 = iHigh(Symbol(), g_timeframe_76, l_shift_4);
         gi_172 = Time[l_shift_4];
         ObjectDelete(g_timeframe_76 + " Hi TL");
         ObjectCreate(g_timeframe_76 + " Hi TL", OBJ_TREND, 0, gi_168, gd_136, gi_172, gd_144);
         ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_RAY, TRUE);
         ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_COLOR, g_color_84);
      }
   }
   initial.final.high.TL();
}

void initial.final.high.TL() {
   gd_160 = gd_136;
   gi_180 = gi_168;
   gd_152 = gd_144;
   gi_176 = gi_172;
   gd_136 = gd_152;
   gi_168 = gi_176;
   gd_144 = gd_160;
   gi_172 = gi_180;
   ObjectDelete(g_timeframe_76 + " Hi TL");
   ObjectCreate(g_timeframe_76 + " Hi TL", OBJ_TREND, 0, gi_168, gd_136, gi_172, gd_144);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Hi TL", OBJPROP_COLOR, g_color_84);
}

void initial.temp.low.TL() {
   if (iLow(Symbol(), g_timeframe_76, 0) > iLow(Symbol(), g_timeframe_76, 1)) {
      gd_88 = iLow(Symbol(), g_timeframe_76, 1);
      gi_120 = iTime(Symbol(), g_timeframe_76, 1);
   } else {
      gd_88 = iLow(Symbol(), g_timeframe_76, 0);
      gi_120 = iTime(Symbol(), g_timeframe_76, 0);
   }
   gd_96 = iLow(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_120) + 1);
   gi_124 = iTime(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_120) + 1);
   ObjectCreate(g_timeframe_76 + " Lo TL", OBJ_TREND, 0, gi_120, gd_88, gi_124, gd_96);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_COLOR, g_color_84);
   int l_shift_0 = iBarShift(Symbol(), g_timeframe_76, gi_124);
   for (int l_shift_4 = l_shift_0; l_shift_4 < l_shift_0 + shift; l_shift_4++) {
      if (iLow(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && iLow(Symbol(), g_timeframe_76, l_shift_4) < ObjectGetValueByShift(g_timeframe_76 + " Lo TL", l_shift_4)) {
         gd_96 = iLow(Symbol(), g_timeframe_76, l_shift_4);
         gi_124 = Time[l_shift_4];
         ObjectDelete(g_timeframe_76 + " Lo TL");
         ObjectCreate(g_timeframe_76 + " Lo TL", OBJ_TREND, 0, gi_120, gd_88, gi_124, gd_96);
         ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_RAY, TRUE);
         ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_COLOR, g_color_84);
      }
   }
   secondary.temp.low.TL();
}

void secondary.temp.low.TL() {
   gd_88 = gd_96;
   gi_120 = gi_124;
   gd_96 = iLow(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_120) + 1);
   gi_124 = iTime(Symbol(), g_timeframe_76, iBarShift(Symbol(), g_timeframe_76, gi_120) + 1);
   ObjectDelete(g_timeframe_76 + " Lo TL");
   ObjectCreate(g_timeframe_76 + " Lo TL", OBJ_TREND, 0, gi_120, gd_88, gi_124, gd_96);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_COLOR, g_color_84);
   int l_shift_0 = iBarShift(Symbol(), g_timeframe_76, gi_124);
   for (int l_shift_4 = l_shift_0; l_shift_4 < l_shift_0 + shift; l_shift_4++) {
      if (iLow(Symbol(), g_timeframe_76, l_shift_4) > 0.0 && iLow(Symbol(), g_timeframe_76, l_shift_4) < ObjectGetValueByShift(g_timeframe_76 + " Lo TL", l_shift_4)) {
         gd_96 = iLow(Symbol(), g_timeframe_76, l_shift_4);
         gi_124 = Time[l_shift_4];
         ObjectDelete(g_timeframe_76 + " Lo TL");
         ObjectCreate(g_timeframe_76 + " Lo TL", OBJ_TREND, 0, gi_120, gd_88, gi_124, gd_96);
         ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_RAY, TRUE);
         ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_COLOR, g_color_84);
      }
   }
   initial.final.low.TL();
}

void initial.final.low.TL() {
   gd_112 = gd_88;
   gi_132 = gi_120;
   gd_104 = gd_96;
   gi_128 = gi_124;
   gd_88 = gd_104;
   gi_120 = gi_128;
   gd_96 = gd_112;
   gi_124 = gi_132;
   ObjectDelete(g_timeframe_76 + " Lo TL");
   ObjectCreate(g_timeframe_76 + " Lo TL", OBJ_TREND, 0, gi_120, gd_88, gi_124, gd_96);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_RAY, TRUE);
   ObjectSet(g_timeframe_76 + " Lo TL", OBJPROP_COLOR, g_color_84);
}
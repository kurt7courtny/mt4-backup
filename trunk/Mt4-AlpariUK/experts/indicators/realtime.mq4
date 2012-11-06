/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "wfy05@talkforex.com"
#property link      "http://www.talkforex.com"
#property show_inputs

#property indicator_chart_window

#include <WinUser32.mqh>

extern double Version = 1.3;
extern string BuildInfo = "2005.12.04 by wfy05@talkforex.com";
extern int PeriodMultiplier = 2;
extern int UpdateInterval = 0;
extern bool Enabled = TRUE;
extern bool Debug = FALSE;
int g_file_108 = -1;
int gi_112 = 0;
int gi_116;
int gi_120;
double g_open_124;
double g_low_132;
double g_high_140;
double g_close_148;
double g_volume_156;
int gi_164 = 0;
int g_time_168 = 0;
int g_time_172 = 0;
int g_bars_176 = 0;
int g_bars_180 = 0;
int g_time_184 = 0;
int g_volume_188 = 0;
double g_open_192 = 0.0;
double g_close_200 = 0.0;
double g_high_208 = 0.0;
double g_low_216 = 0.0;
string gs_224 = "";
int gi_232 = 0;

void DebugMsg(string as_0) {
   if (Debug) Alert(as_0);
}

int init() {
   gi_112 = Period() * PeriodMultiplier;
   if (OpenHistoryFile() < 0) return (-1);
   WriteHistoryHeader();
   WriteHistoryFile(Bars - 1, 1);
   UpdateChartWindow();
   return (0);
}

void deinit() {
   if (g_file_108 >= 0) {
      FileClose(g_file_108);
      g_file_108 = -1;
   }
}

int OpenHistoryFile() {
   g_file_108 = FileOpenHistory(Symbol() + gi_112 + ".hst", FILE_BIN|FILE_WRITE);
   if (g_file_108 < 0) return (-1);
   return (0);
}

int WriteHistoryHeader() {
   int l_digits_8 = Digits;
   int lia_12[13] = {0};
   int li_16 = 400;
   if (g_file_108 < 0) return (-1);
   string ls_0 = "(C)opyright 2003, MetaQuotes Software Corp.";
   FileWriteInteger(g_file_108, li_16, LONG_VALUE);
   FileWriteString(g_file_108, ls_0, 64);
   FileWriteString(g_file_108, Symbol(), 12);
   FileWriteInteger(g_file_108, gi_112, LONG_VALUE);
   FileWriteInteger(g_file_108, l_digits_8, LONG_VALUE);
   FileWriteInteger(g_file_108, 0, LONG_VALUE);
   FileWriteInteger(g_file_108, 0, LONG_VALUE);
   FileWriteArray(g_file_108, lia_12, 0, ArraySize(lia_12));
   return (0);
}

int WriteHistoryFile(int ai_0, bool ai_4 = FALSE) {
   int li_8;
   datetime l_time_20;
   if (g_file_108 < 0) return (-1);
   int li_12 = 60 * gi_112;
   gi_120 = Time[ai_0] / li_12;
   gi_120 *= li_12;
   if (ai_4) {
      g_open_124 = Open[ai_0];
      g_low_132 = Low[ai_0];
      g_high_140 = High[ai_0];
      g_close_148 = Close[ai_0];
      g_volume_156 = Volume[ai_0];
      li_8 = ai_0 - 1;
   } else {
      li_8 = ai_0;
      FileSeek(g_file_108, gi_116, SEEK_SET);
   }
   if (li_8 < 0) return (-1);
   int l_count_16 = 0;
   while (li_8 >= 0) {
      l_time_20 = Time[li_8];
      if (l_time_20 >= gi_120 + li_12) {
         FileWriteInteger(g_file_108, gi_120, LONG_VALUE);
         FileWriteDouble(g_file_108, g_open_124, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, g_low_132, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, g_high_140, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, g_close_148, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, g_volume_156, DOUBLE_VALUE);
         l_count_16++;
         gi_120 = l_time_20 / li_12;
         gi_120 *= li_12;
         g_open_124 = Open[li_8];
         g_low_132 = Low[li_8];
         g_high_140 = High[li_8];
         g_close_148 = Close[li_8];
         g_volume_156 = Volume[li_8];
      } else {
         g_volume_156 += Volume[li_8];
         if (Low[li_8] < g_low_132) g_low_132 = Low[li_8];
         if (High[li_8] > g_high_140) g_high_140 = High[li_8];
         g_close_148 = Close[li_8];
      }
      li_8--;
   }
   gi_116 = FileTell(g_file_108);
   FileWriteInteger(g_file_108, gi_120, LONG_VALUE);
   FileWriteDouble(g_file_108, g_open_124, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, g_low_132, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, g_high_140, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, g_close_148, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, g_volume_156, DOUBLE_VALUE);
   l_count_16++;
   g_volume_156 -= Volume[0];
   FileFlush(g_file_108);
   return (l_count_16);
}

int UpdateChartWindow() {
   if (gi_164 == 0) gi_164 = WindowHandle(Symbol(), gi_112);
   if (gi_164 != 0) {
      if (IsDllsAllowed() == FALSE) {
         DebugMsg("Dll calls must be allowed");
         return (-1);
      }
      if (PostMessageA(gi_164, WM_COMMAND, 33324, 0) == 0) gi_164 = 0;
      else return (0);
   }
   return (-1);
}

int reinit() {
   deinit();
   init();
   g_time_168 = Time[Bars - 1];
   g_time_172 = Time[0];
   g_bars_176 = Bars;
   return (0);
}

bool IsDataChanged() {
   if (g_volume_188 != Volume[0] || g_bars_180 != Bars || g_time_184 != Time[0] || g_close_200 != Close[0] || g_high_208 != High[0] || g_low_216 != Low[0] || g_open_192 != Open[0]) {
      g_bars_180 = Bars;
      g_volume_188 = Volume[0];
      g_time_184 = Time[0];
      g_close_200 = Close[0];
      g_high_208 = High[0];
      g_low_216 = Low[0];
      g_open_192 = Open[0];
      return (TRUE);
   }
   return (FALSE);
}

int CheckNewData() {
   if (Bars < 2) {
      DebugMsg("Data not loaded, only " + Bars + " Bars");
      return (-1);
   }
   string ls_0 = AccountServer();
   if (ls_0 == "") {
      DebugMsg("No server connected");
      return (-1);
   }
   if (gs_224 != ls_0) {
      DebugMsg("Server changed from " + gs_224 + " to " + ls_0);
      gs_224 = ls_0;
      reinit();
      return (-1);
   }
   if (!IsDataChanged()) return (-1);
   if (Time[Bars - 1] != g_time_168) {
      DebugMsg("Start time changed, new history loaded or server changed");
      reinit();
      return (-1);
   }
   for (int l_index_8 = 0; l_index_8 < Bars; l_index_8++)
      if (Time[l_index_8] <= g_time_172) break;
   if (l_index_8 >= Bars || Time[l_index_8] != g_time_172) {
      DebugMsg("End time " + TimeToStr(g_time_172) + " not found");
      reinit();
      return (-1);
   }
   int li_12 = Bars - l_index_8;
   if (li_12 != g_bars_176) {
      DebugMsg("Data loaded, cnt is " + li_12 + " LastBarCount is " + g_bars_176);
      reinit();
      return (-1);
   }
   g_bars_176 = Bars;
   g_time_172 = Time[0];
   return (l_index_8);
}

int start() {
   int li_0;
   if (!Enabled) return (0);
   if (UpdateInterval != 0) {
      li_0 = GetTickCount();
      if (MathAbs(li_0 - gi_232) < UpdateInterval) return (0);
      gi_232 = li_0;
   }
   int li_4 = CheckNewData();
   if (li_4 < 0) return (0);
   WriteHistoryFile(li_4);
   UpdateChartWindow();
   return (0);
}
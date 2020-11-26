package com.cc.pms.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TimeUtil {
	public static String getFormatTime() {
		LocalDateTime rightNow=LocalDateTime.now();
		String date=rightNow.format(DateTimeFormatter.ISO_DATE);
		int hour=rightNow.getHour();
		int minute=rightNow.getMinute();
		String formatDate=date+"T"+hour+":"+minute;
		return formatDate;

	}
}



//method for converting the token of sunset string to int
//to convert it from 12-hour to 24-hour system
String convertTwelveToTwentyFour(String token) {
  int pm = Integer.parseInt(token);
  pm += 12;
  String newHour = pm + "";
  return newHour;
}

int getTimeInTZ(int h, int m) {
  //unlike above method, takes in two parameters that have been converted to a different time zone
  //used only for updating weather info when time zone changes
  
  if (m < 10) {
    String tempH = h + "0";
    h = Integer.parseInt(tempH);
  }
  String tempTime = h + "" + m;
  //use this time to compare to the sunrise and sunset
  int comparedTime = Integer.parseInt(tempTime);
  return comparedTime;
}

/*
Simple method that gets the time zone to use from the array of cities and selects its associated time zone.
*/
TimeZone getTimeZoneFromList(String city) {
  TimeZone timeZone = null;
    for (int i = 0; i < myArray.length; i++) {
      if (city.equals(myArray[i][0])) {
        timeZone = TimeZone.getTimeZone(myArray[i][2]);
      }
    }
    
    return timeZone;
}

/*
Simply displays the updated time; used mainly in the updateWeatherText() method for the "Last updated: " line of text
*/
private String displayUpdatedTime(Date date) {
  SimpleDateFormat priv_sdf = new SimpleDateFormat("h:mm a");
  String priv_time = priv_sdf.format(date);
  return priv_time.toLowerCase();
}


//private method to get local time of cities outside of current time zone (Eastern Standard/Daylight Time)
private String getCurrentTimeInTimeZone(Date date, boolean dst) {
  SimpleDateFormat sdf = new SimpleDateFormat("h:mm a");
  String time_temp = sdf.format(date);
  
  String[] dateTokens = splitTokens(time_temp, ": ");
  int hour = Integer.parseInt(dateTokens[0]);    
  String minute = dateTokens[1];
  String abbr = dateTokens[2];
    
  //checks if the time zone is using daylight savings or matches any of these specific time zones
  //if not, then set hour behind 1
  if (!dst || tz_temp.getID().equals("Australia/Sydney") || tz_temp.getID().equals("Europe/London") || tz_temp.getID().equals("America/Sao_Paulo")) {
    if (hour == 12 && abbr.equals("AM")) {
      hour -= 1;
      abbr = "PM";
    } else if (hour == 12 && abbr.equals("PM")) {
      hour -= 1;
      abbr = "AM";
    } else {
      hour -= 1;
    }
    
    if (hour == 0) {
      hour = 12;
    }
  } 
  String time = hour +":" + minute + " " + abbr;
  return time.toLowerCase(); 
}

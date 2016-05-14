

/*
first, we get the time of sunrise from weather and we separate each token.
We take the first two tokens only (hour and minutes), turn it into an int and
use to compare it to the current local time displayed.
*/
int getSunrise() {
  String rise = weather.getSunrise();
  String[] riseTokens = splitTokens(rise, ": ");
  //create temporary strings containing tokens of both times for sunrise and sunset  
  String am = riseTokens[0] + riseTokens[1];
  int sunrise = Integer.parseInt(am);
  return sunrise;
}

/*
this method is similar to getSunrise() but includes an extra part which will be described below
*/
private int getThirtyMinAfterRise() {
  String rise = weather.getSunrise();
  String[] tokens = splitTokens(rise, ": ");
  int hour = Integer.parseInt(tokens[0]);
  int minute = Integer.parseInt(tokens[1]);
  
  /*
  This is a special case if the minute value is between 30 and 59.
  Since this has been parsed as an integer, adding 30 to any of these numbers would make them go outside the
  range of the clock system (ie, 30 to 60 and 59 to 89).  So, by subtracting 30 minutes from the current
  minutes while adding an hour ensures that half hour after 6:30 am, for example, can be read as 7:00 am
  instead of 7:60 am; or half hour after 6:59 am is read as 7:29 am instead of 6:89 am.
  */
  if (minute > 30 && minute <= 59) {
    hour += 1;
    minute -= 30;
  } else {
    minute += 30;
    
    if (minute == 60) {
      minute -= 60;
    }
  }
  
  if (minute < 10) {
    String tempH = hour + "0";
    hour = Integer.parseInt(tempH);
  }
 
 //concatenate the two integers as a string then parse it as a new integer 
 //(ie, hour = 7 and minute = 30 become 730 instead of 37 if we added the integers instead of concatenating them)
  String temp = hour + "" + minute;
  int thirtyAfter = Integer.parseInt(temp);
  return thirtyAfter;
}

/*
Similar process to sunrise, but we must also call the convertTwelveToTwentyFour method
to change the time from, for example, 7:30 pm to 19:30, and then use 1930 to comparing times
for the day-and-night cycle.
*/
int getSunset() {
  String set = weather.getSunset();
  String[] setTokens = splitTokens(set, ": ");
  //convert the 12-hour system into 24-hour system only for sunset hour  
  setTokens[0] = convertTwelveToTwentyFour(setTokens[0]);
  String pm = setTokens[0] + setTokens[1];
  int sunset = Integer.parseInt(pm);
  return sunset;
}

/*
This method works very similar to the getThirtyMinAfterRise() method above but reverses the operations.
*/
private int getThirtyMinBeforeSet() {
  String set = weather.getSunset();
  String[] tokens = splitTokens(set, ": ");
  tokens[0] = convertTwelveToTwentyFour(tokens[0]);
  int hour = Integer.parseInt(tokens[0]);
  int minute = Integer.parseInt(tokens[1]);
  /*
  This is a special case if the minute value is between 00 and 29.
  Since this has been parsed as an integer, subtracting 30 to any of these numbers would make them go outside the
  range of the clock system (ie, 00 to 29 and -30 to -1).  So, by adding 30 minutes from the current
  minutes while subtracting an hour ensures that half hour after 7:00 pm, for example, can be read as 6:30 am
  instead of 7:-30 pm; or half hour after 7:29 pm is read as 6:59 pm instead of 7:-1 pm.
  */
  if (minute > 0 && minute <= 29) {
    minute += 30;
    hour -= 1;
  } else {
    minute -= 30;
    if (minute == 60) {
      minute -= 60;
    }
  }
  
  if (minute < 10) {
    String tempH = hour + "0";
    hour = Integer.parseInt(tempH);
  }
  
 //concatenate the two integers as a string then parse it as a new integer 
 //(ie, hour = 7 and minute = 30 become 730 instead of 37 if we added the integers instead of concatenating them)
  String temp = hour +"" + minute;
  int thirtyBefore = Integer.parseInt(temp);
  return thirtyBefore;
}

int getCurrentTime() {
  //setting up the time from the computer to use for comparing the times of sunrise and sunset
  int h = hour();
  int m = minute();

   /*
  If there are less than 10 minutes, add an extra zero to hour
  ie, if we have 1:00 pm, we need it as 1300.    The hour() method returns the hour in a 24-hour system (ranging from 0-23)
  However, the minute() methods does not return numbers 0-9 as '00' and etc. the method returns numbers 0-9 as '0' and etc.
  Hence, we add an extra 0 to the hour string such that we have 1300 instead of 130.  This is important when we use this time
  to compare to the sunrise, sunset, and other times for the day-night cycle to work in the method.
  */
  if (m < 10) {
    String tempH = h + "0";
    h = Integer.parseInt(tempH);
  }
  String tempTime = h + "" + m;
  //use this time to compare to the sunrise and sunset
  int comparedTime = Integer.parseInt(tempTime);
  return comparedTime;
}

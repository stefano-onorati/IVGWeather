

private String timeTZ = "";
private TimeZone tz_temp = TimeZone.getDefault();

void setBGC(int comparedTime, int sunrise, int sunset) {
  //different background colours for different periods of a 24-hour day
  //first - time between sunset and 30 minutes before (dusk)
  //second - time between sunrise and 30 minutes after (dawn)
  //third - after sunset and before sunrise (night)
  //fourth -  between 30 after sunrise and 30 before sunset (day)
  int before = getThirtyMinBeforeSet();
  int after = getThirtyMinAfterRise();
  
  println(sunrise + " | " + after + " | " + comparedTime + " | " + before + " | " + sunset);
  
  if (comparedTime >= before && comparedTime < sunset) {
    bgR=253;
    bgG=94;
    bgB=83;
    fillTextR = 250;
    fillTextG = 240;
    fillTextB = 230;
  } else if (comparedTime >= sunrise && comparedTime < after) {
    bgR=223;
    bgG=156;
    bgB=45;
    fillTextR = 250;
    fillTextG = 235;
    fillTextB = 215;
  } else if (comparedTime >= sunset || comparedTime < sunrise) {
    bgR=0;
    bgG=0;
    bgB=0;
    fillTextR = 255;
    fillTextG = 255;
    fillTextB = 255;
  } else if (comparedTime >= after && comparedTime < before) {
    bgR=255;
    bgG=250;
    bgB=225;
    fillTextR = 0;
    fillTextG = 100;
    fillTextB = 0;
  }
}

/*
This methods updates all necessary information regarding weather and time.
Converts to the time zone that is in use and sets up the time necessary
for the day-and-night cycle on the sketch.  Once the time is set, we
get the times of sunrise and sunset, along with new wind speed.
We call methods in here to set new speed of ellipses, change background color,
get the time in new time zone to display as text, and to get new weather info text in sketch.
*/
void updateWeatherInfo(SimpleDateFormat sdf, Date date, String city) {
    weather.update();
    SimpleDateFormat sdf_temp = new SimpleDateFormat("H:mm");
    tz_temp = getTimeZoneFromList(city);
        
    sdf_temp.setTimeZone(tz_temp);
    String dateString_temp = sdf_temp.format(date);
    Date date_temp = sdf.parse(dateString_temp, new ParsePosition(0));

    String[] dateTokens = splitTokens(sdf.format(date_temp), ": ");
    int hour = Integer.parseInt(dateTokens[0]);    
    int minute = Integer.parseInt(dateTokens[1]);
    
    if (!tz_temp.useDaylightTime() || tz_temp.getID().equals("Australia/Sydney") || tz_temp.getID().equals("Europe/London") || tz_temp.getID().equals("America/Sao_Paulo")) {
      hour -= 1;
    } 
    
    int comparedTime = getTimeInTZ(hour, minute);
    int sunrise = getSunrise();
    int sunset = getSunset();
    float speed = weather.getWindSpeed();
    int temperature = weather.getTemperature();

    assignSpeedOfEllipses(speed, weather.getWindDirection());
    assignSizeOfEllipses(temperature);
    setBGC(comparedTime,sunrise,sunset);
    timeTZ = getCurrentTimeInTimeZone(date_temp, tz_temp.useDaylightTime());
    getWeatherInfoText(weather);
}

//text to change when city/weather changes in sketch
void getWeatherInfoText(YahooWeather weather) {
  TimeZone defaultTZ = TimeZone.getDefault();
  fill(191,127);
  rect(5,5,485,220,10);
  fill(fillTextR, fillTextG, fillTextB);
  text(weather.getCityName()+", "+weather.getCountryName(), 10, 30);
  text("Temperature: " + weather.getTemperature() + "\u00b0C", 10, 60);
  text("Weather Condition: " + weather.getWeatherCondition(), 10, 90);
  text("Wind Speed & Direction: "+weather.getWindSpeed()+" km/h "+getCompassDirection(weather.getWindDirection()), 10, 120);
  text("Sunrise: "+weather.getSunrise()+"  Sunset: "+weather.getSunset(), 10, 150);
  if (tz_temp.getID().equals("America/Toronto") || tz_temp.getID().equals("America/New_York") || tz_temp.getID().equals("America/Havana") || timeTZ.equals("")) {
    text("Last updated: "+displayUpdatedTime(weather.getLastUpdated()) + " " + defaultTZ.getDisplayName(defaultTZ.useDaylightTime(), TimeZone.SHORT), 10, 180);  
  } else {
    text("Local Time: " + timeTZ + " " + tz_temp.getDisplayName(tz_temp.useDaylightTime(), TimeZone.SHORT), 10, 180);
    text("Last updated: "+displayUpdatedTime(weather.getLastUpdated()) + " " + defaultTZ.getDisplayName(defaultTZ.useDaylightTime(), TimeZone.SHORT), 10, 210);  
  } 
}


import java.util.*;
import java.text.*;

import com.onformative.yahooweather.*;
import oscP5.*;
import netP5.*;

YahooWeather weather;
OscP5 osc;
NetAddress address;

PFont font;
int updateIntervallMillis = 60000;
int now;
int howMany = 100;// 100?
String searchString = "#IVGYorku";

TimeZone timezone;

int wcc = 0;

String time = "";
public color colorSelected;

float bgR = 0;
float bgG = 0;
float bgB = 0;
float speed = 0;
int temperature = 0;
int sunrise = 0;
int sunset = 0;
int comparedTime = 0;
int windDirection = 0;
int xWindVelocity = 0;
int yWindVelocity = 0; 
float fillTextR = 0;
float fillTextG = 0;
float fillTextB = 0;
//here you make empty arrays
float[] xv  = new float[howMany];
float[] yv  = new float[howMany];
float[] ew = new float[howMany];
float[] eh = new float[howMany];
float[] xsp = new float[howMany];
float[] ysp = new float[howMany];

int h;
int m;
int WOEID;
String dateString;
  
SimpleDateFormat sdf;
Date date;
String city;
String city_OSC;


int[] codes = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 3200
  };
  
color[] colors = {
    color(220), color(113,198,113), color(255,0,0), color(139,34,82), color(178,74,122),
    color(185,239,248), color(141,182,205), color(231,239,255), color(173,195,238), color(198,225,255),
    color(214,235,245), color(30,144,255), color(30,144,255), color(255,250,250), color(213,246,250),
    color(248,248,255), color(255), color(232,232,245), color(182,229,248), color(255,193,37), color(240),
    color(225,238,225), color(238,238,225), color(245), color(0,128,128), color(0,0,255), color(122,138,144),
    color(39,64,89), color(139,137,112), color(159,182,205), color(205,201,165), color(25,25,112),
    color(255,255,0), color(16,78,139), color(208,208,0), color(51,161,201), color(238,92,66),
    color(186,177,232), color(167,154,205), color(167,154,205), color(185,211,238), color(255,253,253),
    color(255,253,253), color(255,253,253), color(192), color(106,90,205), color(176,225,255), color(185,149,205), color(45)
    
};
  
  /*
  array for checking what city is currently displayed; also contains their WOEID
  */
String[][] myArray = { {"Toronto","4118", "America/Toronto"}, 
                       {"Ottawa", "29375164", "America/Toronto"},
                       {"London", "44418", "Europe/London"},
                       {"New York City", "2459115", "America/New_York"},
                       {"Miami", "2450022", "America/New_York"},
                       {"Paris", "615702", "Europe/Paris"},
                       {"Prague", "796597", "Europe/Prague"},
                       {"Milan", "718345", "Europe/Rome"},
                       {"Las Vegas", "2436704", "America/Los_Angeles"},
                       {"Seattle", "2490383", "America/Los_Angeles"},
                       {"Vancouver", "9807", "America/Vancouver"},
                       {"Bangkok", "1225448", "Asia/Bangkok"},
                       {"Dubai", "1940345", "Asia/Dubai"},
                       {"Rome", "721943", "Europe/Rome"},
                       {"Shanghai", "2151849", "Asia/Shanghai"},
                       {"Dublin", "560743", "Europe/London"},
                       {"Los Angeles", "2442047", "America/Los_Angeles"},
                       {"Moscow", "2122265", "Europe/Moscow"},
                       {"Cairo", "1521894", "Africa/Cairo"},
                       {"Madrid", "766273", "Europe/Madrid"},
                       {"San Francisco", "2487956", "America/Los_Angeles"},
                       {"Budapest", "804365", "Europe/Budapest"},
                       {"Rio de Janeiro", "455825", "America/Sao_Paulo"},
                       {"Berlin", "638242", "Europe/Berlin"},
                       {"Tokyo", "1118370", "Asia/Tokyo"},
                       {"Mexico City", "116545", "America/Mexico_City"},
                       {"St. Petersburg", "2123260", "Europe/Moscow"},
                       {"Seoul", "1132599", "Asia/Seoul"},
                       {"Jerusalem", "1968222", "Asia/Jerusalem"},
                       {"Delhi", "2295019", "Asia/Calcutta"},
                       {"Sydney","1105779", "Australia/Sydney"},
                       {"Chicago", "2379574", "America/Chicago"},
                       {"Havana", "63817", "America/Havana"},
                       {"Calgary", "8775", "America/Edmonton"},
                       {"Montreal", "3534", "America/Toronto"},
                       {"Amsterdam", "727232", "Europe/Amsterdam"},
                       {"Istanbul", "2344116", "Europe/Istanbul"},
                       {"Brussels", "968019", "Europe/Brussels"},
                       {"Montego Bay", "109455", "America/Jamaica"},
                       {"Hong Kong", "24865698", "Asia/Hong_Kong"}
                     };

void setup() {
  size(displayWidth,displayHeight);
  fill(0);
  ellipseMode(CENTER);
  noStroke();
  font = loadFont("HelveticaNeue-Medium-24.vlw");
  textFont(font,24);
  // use this site to find out about your WOEID : http://sigizmund.info/woeidinfo/
  weather = new YahooWeather(this, 4118, "c", updateIntervallMillis); //Toronto's WOEID (4118)
  now = millis();
  
  osc = new OscP5(this, 8001);
  address = new NetAddress("127.0.0.1", 8000);
  
  timezone = TimeZone.getDefault();
    
  h = hour();
  m = minute();
  WOEID = 0;
  dateString = h + ":" + m;
  sdf = new SimpleDateFormat("H:mm");
  date = sdf.parse(dateString, new ParsePosition(0));
  
  city = "Toronto"; 
  city_OSC = "";
  
  updateWeatherInfo(sdf, date, city);
  setEllipseCoordinates(weather.getWindDirection());
}

void draw() {
  weather.update();
  wcc = weather.getWeatherConditionCode();

  
  //the purpose of this final int is to update the sketch
  //whenever time changes, so that local time displayed is
  //up to date and not behind the last updated time
  final int updateMinute = updateIntervallMillis;
  
  if (millis() - now >= updateMinute) {
    h = hour();
    m = minute();
    dateString = h + ":" + m;
    date = sdf.parse(dateString, new ParsePosition(0));
    
    if (!city_OSC.equals(city) && !city_OSC.equals("")) {
      city = city_OSC;
      WOEID = getWOEIDFromList(city);
      weather.setWOEID(WOEID); 
      updateWeatherInfo(sdf, date, city);
      setEllipseCoordinates(weather.getWindDirection());
    } else {
      updateWeatherInfo(sdf, date, city);
      setEllipseCoordinates(weather.getWindDirection());
    }
    
    now = millis();
  }
  
  background(bgR, bgG, bgB);
  
  for (int i = 0; i < codes.length; i++) {
    if (codes[i] == wcc) {
      colorSelected = colors[i];
      fill(colorSelected, 155);
    }
  }
//populate the screen with ellipses
  for (int i =0; i < xv.length; i++) {

    if (xv[i] > width) {
      xv[i] = 0;
      yv[i] = height - yv[i];
    } else if (yv[i] > height) {
      xv[i] = width - xv[i];
      yv[i] = 0;
    } else if (xv[i] < 0) {
      xv[i] = width;
      yv[i] = height - yv[i];
    } else if (yv[i] < 0) {
      xv[i] = width - xv[i];
      yv[i] = height;
    }
    
    ellipse(xv[i], yv[i], ew[i],eh[i]);
    xv[i] = xv[i] + (xsp[i]*xWindVelocity); 
    yv[i] = yv[i] + (ysp[i]*yWindVelocity);
  }

  getWeatherInfoText(weather);  
}

int getWOEIDFromList(String city) {
  int woeid = 0;
    for (int i = 0; i < myArray.length; i++) {
      if (city.equals(myArray[i][0])) {
        woeid = Integer.parseInt(myArray[i][1]);
        break;
      }
    }
    
    return woeid;
}

void oscEvent(OscMessage msg) {
  city_OSC = msg.get(0).stringValue();
}

boolean sketchFullScreen() 
{
  return true;
}

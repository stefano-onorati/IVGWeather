import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;
import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress address;

Twitter twitter;
String searchString = "#IVGYorku";
List<Status> tweets;
int currentTweet;
int now;
String[] cities = { "Toronto", "Ottawa", "London", "New York City", "Miami", "Paris", 
                    "Prague", "Milan", "Las Vegas", "Seattle", "Vancouver", "Bangkok", 
                    "Dubai", "Rome", "Shanghai", "Dublin", "Los Angeles", "Moscow", "Cairo", 
                    "Madrid", "San Francisco", "Budapest", "Rio de Janeiro", "Berlin", 
                    "Tokyo", "Mexico City", "St. Petersburg", "Seoul", "Jerusalem", 
                    "Delhi", "Sydney", "Chicago", "Havana", "Calgary", "Montreal", 
                    "Amsterdam", "Istanbul", "Brussels", "Montego Bay", "Hong Kong"
                     };

void setup()
{
  size(100,100);
  osc = new OscP5(this, 8000);
  address = new NetAddress("127.0.0.1", 8001);
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("aSTDGbOG7WvnImF1qWbQrv315");
  cb.setOAuthConsumerSecret("08FNDFewfGiUCiaB6YCIkmlBZGbFWXXD8z91PByrQiC3nDfnXM");
  cb.setOAuthAccessToken("880662985-GxEn7AHa7mGQooWN66eOKfVGihsCoH3DkRCT4fes");
  cb.setOAuthAccessTokenSecret("WoNdjcwcN9NH7OQiDdPgXf7xpHEAQ11QdywPnRBjMvGaf");
  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();
  getNewTweets();
  currentTweet = 0;
  thread("refreshTweets");
  now = millis();
}

void draw()
{
//    fill(0, 40);
//    rect(0, 0, width, height);
//    currentTweet = currentTweet + 1;
//    if (currentTweet >= tweets.size())
//    {
//        currentTweet = 0;
//    }
//    Status status = tweets.get(currentTweet);
//    fill(200);
//    text(status.getText(), random(width), random(height), 300, 200);
//    delay(250);
}

void getNewTweets()
{
    try 
    {
        Query query = new Query(searchString);
        QueryResult result = twitter.search(query);
        tweets = result.getTweets();
        
        for (int i = 0; i < tweets.size(); i++) {
          for (int j = 0; j < cities.length; j++) {
            if (tweets.get(i).getText().contains(cities[j])) {
              OscMessage msg = new OscMessage("/test");
              msg.add(cities[j]);
              osc.send(msg, address);
              println("SENDING THIS MESSAGE: " + cities[j]);
              break;
            }
          }
          break;
        }
    } 
    catch (TwitterException te) 
    {
        System.out.println("Failed to search tweets: " + te.getMessage());
        System.exit(-1);
    } 
}

void refreshTweets()
{
    while (true)
    {
        getNewTweets();
        println("Updated Tweets"); 
        delay(60000);
    }
}

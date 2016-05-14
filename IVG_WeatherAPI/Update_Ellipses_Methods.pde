

float xCoor = 0;
float yCoor = 0;

/*
method to assign size of ellipses based on temperature in Celsius
*/
void assignSizeOfEllipses(int temperature) {
  
  float ellipseSize = (temperature+50)*1.68+8;
  
 for (int i = 0; i < xsp.length; i++) {
    eh[i] = ellipseSize;
    ew[i] = eh[i];
 }
}

/*
Returns the cardinal compass direction of the wind, determined by the degree of the wind's direction.
Nabil: Added in two extra variables to change whether the x or y coordinate is increasing or decreasing depending on the direction of the wind.
eg for a NNE wind, the x-coordinate needs to decrease and the y-coordinate needs to increase, therefore xWindVelocity = -1 and yWindVelocity = 1 
*/
private String getCompassDirection(int direction) {
  String cardinalPoint = "";
  
  if (direction > 11 && direction <= 33) {
    cardinalPoint = "NNE";
    xWindVelocity = -1;
    yWindVelocity = 1;
  } else if (direction > 33 && direction <= 56) {
    cardinalPoint = "NE";
    xWindVelocity = -1;
    yWindVelocity = 1;
  } else if (direction > 56 && direction <= 78) {
    cardinalPoint = "ENE";
    xWindVelocity = -1;
    yWindVelocity = 1;
  } else if (direction > 78 && direction <= 101) {
    cardinalPoint = "E";
    xWindVelocity = -1;
    yWindVelocity = 0; 
  } else if (direction > 101 && direction <= 123) {
    cardinalPoint = "ESE";
    xWindVelocity = -1;
    yWindVelocity = -1; 
  } else if (direction > 123 && direction <= 146) {
    cardinalPoint = "SE";
    xWindVelocity = -1;
    yWindVelocity = -1; 
  } else if (direction > 146 && direction <= 168) {
    cardinalPoint = "SSE";
    xWindVelocity = -1;
    yWindVelocity = -1; 
  } else if (direction > 168 && direction <= 191) {
    cardinalPoint = "S";
    xWindVelocity = 0;
    yWindVelocity = -1;
  } else if (direction > 191 && direction <= 213) {
    cardinalPoint = "SSW";
    xWindVelocity = 1;
    yWindVelocity = -1; 
  } else if (direction > 213 && direction <= 236) {
    cardinalPoint = "SW";
    xWindVelocity = 1;
    yWindVelocity = -1;
  } else if (direction > 236 && direction <= 258) {
    cardinalPoint = "WSW";
    xWindVelocity = 1;
    yWindVelocity = -1;
  } else if (direction > 258 && direction <= 281) {
    cardinalPoint = "W";
    xWindVelocity = 1;
    yWindVelocity = 0; 
  } else if (direction > 281 && direction <= 303) {
    cardinalPoint = "WNW";
    xWindVelocity = 1;
    yWindVelocity = 1; 
  } else if (direction > 303 && direction <= 326) {
    cardinalPoint = "NW";
    xWindVelocity = 1;
    yWindVelocity = 1; 
  } else if (direction > 326 && direction <= 348) {
    cardinalPoint = "NNW";
    xWindVelocity = 1;
    yWindVelocity = 1; 
  } else if (direction > 348 || direction <= 11) {
    cardinalPoint = "N";
    xWindVelocity = 0;
    yWindVelocity = 1; 
  }
  
   return cardinalPoint;
}

//Nabil:Re-arranged this method with the consideration that (0,0) is the top left of the screen instead of the bottom left.
private void setEllipseCoordinates(int direction) {
  
  if (direction >= 0 && direction <= 90) {
    xCoor = map(direction, 0, 90, width/2,width);
    yCoor = map(direction, 0, 90, 0,height/2);
  } else if (direction > 90 && direction <= 180) {
    xCoor = map(direction, 91, 180, width,width/2);
    yCoor = map(direction, 91, 180, height/2, height);
  } else if (direction > 180 && direction <= 270) {
    xCoor = map(direction, 181, 270, width/2,0);
    yCoor = map(direction, 181, 270, height, height/2);
  } else if (direction > 270 && direction <= 360) {
    xCoor = map(direction, 271, 360, 0, width/2);
    yCoor = map(direction, 271, 360, height/2, 0); 
  }
    
  float lowX = xCoor - (xCoor * 0.02);
  float highX = xCoor + (xCoor * 0.02);
  float lowY = yCoor - (yCoor * 0.02);
  float highY = yCoor + (yCoor * 0.02);
  for (int i = 0; i < xv.length; i++) {    
    xv[i] = random(lowX,highX); 
    yv[i] = random(lowY,highY); 
  }
}

/*
repopulate the speed of each ellipse in the array when wind speed is changed
*/
void assignSpeedOfEllipses(float speed, int direction) {

  float lowSpeed = speed - (speed * 0.10);
  float highSpeed = speed + (speed * 0.10);
   
 for (int i = 0; i < xsp.length; i++) {     //wind speed and direction affect the movement of ellipses
    xsp[i] = random(lowSpeed, highSpeed);
    ysp[i] = random(lowSpeed, highSpeed);
/*    
Nabil: Using the direction, I determined whether the x-speed or y-speed need a multiplier to create a more accurate angle that they traverse across the screen.
eg. for a NNE wind, the y-speed needs to be faster than the x-speed by a significant amount therefore it is multiplied by 3.5
*/
      if (direction > 11 && direction <= 33) { //NNE
      ysp[i] = ysp[i] * 3.5; 
    } else if (direction > 33 && direction <= 56) { //NE
      ysp[i] = ysp[i] * 1.0; 
    } else if (direction > 56 && direction <= 78) { //ENE
      ysp[i] = ysp[i] * 1.5; 
    } else if (direction > 78 && direction <= 101) { //E
      ysp[i] = ysp[i] * 1.0;  
    } else if (direction > 101 && direction <= 123) { //ESE
      xsp[i] = ysp[i] * 3.5; 
    } else if (direction > 123 && direction <= 146) { //SE
      xsp[i] = ysp[i] * 1.0; 
    } else if (direction > 146 && direction <= 168) { //SSE
      xsp[i] = ysp[i] * 1.5;
    } else if (direction > 168 && direction <= 191) { //S
      xsp[i] = ysp[i] * 1.0;
    } else if (direction > 191 && direction <= 213) { //SSW
      ysp[i] = ysp[i] * 3.5;  
    } else if (direction > 213 && direction <= 236) { //SW
      ysp[i] = ysp[i] * 1.0;  
    } else if (direction > 236 && direction <= 258) { //WSW
      xsp[i] = ysp[i] * 3.5; 
    } else if (direction > 258 && direction <= 281) { //W
      ysp[i] = ysp[i] * 1.0; 
    } else if (direction > 281 && direction <= 303) { //WNW
      xsp[i] = ysp[i] * 3.5; 
    } else if (direction > 303 && direction <= 326) { //NW
      ysp[i] = ysp[i] * 1.0; 
    } else if (direction > 326 && direction <= 348) { //NNW
      ysp[i] = ysp[i] * 3.5;  
    } else if (direction > 348 || direction <= 11) { //N
      ysp[i] = ysp[i] * 1.0; 
    }
  } 
}


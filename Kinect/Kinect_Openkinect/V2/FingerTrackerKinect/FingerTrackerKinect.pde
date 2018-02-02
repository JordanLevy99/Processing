import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

// import the fingertracker library
// and the SimpleOpenNI library for Kinect access
import fingertracker.*;
// declare FignerTracker and SimpleOpenNI objects
FingerTracker fingers;
Kinect2 kinect2;
// set a default threshold distance:
// 625 corresponds to about 2-3 feet from the Kinect
int threshold = 625;

void setup() {
  size(640, 480);
  
  // initialize your SimpleOpenNI object
  // and set it up to access the depth image
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  // mirror the depth image so that it is more natural
  //kinect2.enableMirror(true);
  // initialize the FingerTracker object
  // with the height and width of the Kinect
  // depth image
  fingers = new FingerTracker(this, 640, 480);
  // the "melt factor" smooths out the contour
  // making the finger tracking more robust
  // especially at short distances
  // farther away you may want a lower number
  fingers.setMeltFactor(100);
}

void draw() {
  // get new depth data from the kinect
  // get a depth image and display it
  PImage depthImage = kinect2.getDepthImage();
  image(depthImage, 0, 0);

  // update the depth threshold beyond which
  // we'll look for fingers
  fingers.setThreshold(threshold);
  
  // access the "depth map" from the Kinect
  // this is an array of ints with the full-resolution
  // depth data (i.e. 500-2047 instead of 0-255)
  // pass that data to our FingerTracker
  int[] depthMap = kinect2.getRawDepth();
  fingers.update(depthMap);

  // iterate over all the contours found
  // and display each of them with a green line
  stroke(0,255,0);
  for (int k = 0; k < fingers.getNumContours(); k++) {
    fingers.drawContour(k);
  }
  
  // iterate over all the fingers found
  // and draw them as a red circle
  noStroke();
  fill(255,0,0);
  for (int i = 0; i < fingers.getNumFingers(); i++) {
    PVector position = fingers.getFinger(i);
    ellipse(position.x - 5, position.y -5, 10, 10);
  }
  
  // show the threshold on the screen
  fill(255,0,0);
  text(threshold, 10, 20);
}

// keyPressed event:
// pressing the '-' key lowers the threshold by 10
// pressing the '+/=' key increases it by 10 
void keyPressed(){
  if(key == '-'){
    threshold -= 10;
  }
  
  if(key == '='){
    threshold += 10;
  }
}
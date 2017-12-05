import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.openkinect.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Pixels extends PApplet {



Kinect2 kinect2;

public void setup() {
 
 kinect2 = new Kinect2(this);
 kinect2.initDepth();
 kinect2.initDevice();
}

public void draw(){
  background(0);
  //Save the depth data extrated from the camera in img
  PImage img = kinect2.getDepthImage();
  image(img,0,0);

  //skip 20 pixels
  int skip = 10;
  for (int x = 0; x < img.width; x+= skip){
    for (int y = 0; y < img.height; y+= skip){
      int index = x + y * img.width;
      float b = brightness(img.pixels[index]);

      fill(b);
      rect(x,y,skip,skip);
    }
  }
}
  public void settings() {  size(512,424); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Pixels" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
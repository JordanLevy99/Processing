import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Skeleton_Tracking extends PApplet {




//Generate a SimpleOpenNI object
SimpleOpenNI kinect;

Serial myPort;  // Create object from Serial class

public void setup() {
        kinect = new SimpleOpenNI(this);
        kinect.enableDepth();
        kinect.enableUser();// because of the version this change
        
        fill(255, 0, 0);
        kinect.setMirror(true);

        //Open the serial port
        //String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
        //myPort = new Serial(this, portName, 9600);

}

public void draw() {
        kinect.update();
        image(kinect.depthImage(), 0, 0);

        IntVector userList = new IntVector();
        kinect.getUsers(userList);

        if (userList.size() > 0) {
                int userId = userList.get(0);
                //If we detect one user we have to draw it
                if ( kinect.isTrackingSkeleton(userId)) {
                        //User connected
                        //onNewUser(kinect, userId);
                        //Draw the skeleton user
                        drawSkeleton(userId);
                        // get the positions of the three joints of our arm
                        PVector rightHand = new PVector();
                        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
                        PVector rightElbow = new PVector();
                        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
                        PVector rightShoulder = new PVector();
                        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
                        // we need right hip to orient the shoulder angle
                        PVector rightHip = new PVector();
                        kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);
                        // reduce our joint vectors to two dimensions
                        PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
                        PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
                        PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
                        PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
                        // calculate the axes against which we want to measure our angles
                        PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
                        PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);
                        // calculate the angles between our joints
                        float shoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
                        float elbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
                        // show the angles on the screen for debugging
                        fill(255,0,0);
                        scale(3);
                        text("shoulder: " + PApplet.parseInt(shoulderAngle) + "\n" + " elbow: " + PApplet.parseInt(elbowAngle), 20, 20);
                }
        }
}

public void drawSkeleton(int userId) {
        stroke(0);
        strokeWeight(5);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
        noStroke();
        fill(255,0,0);
        drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
        drawJoint(userId, SimpleOpenNI.SKEL_NECK);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
        drawJoint(userId, SimpleOpenNI.SKEL_NECK);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
        drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
        drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

public void drawJoint(int userId, int jointId) {
        PVector joint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointId, joint);
        if(confidence < 0.9f) {
                return;
        }
        PVector convertedJoint = new PVector();
        kinect.convertRealWorldToProjective(joint, convertedJoint);
        ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}
//Generate the angle
public float angleOf(PVector one, PVector two, PVector axis) {
        PVector limb = PVector.sub(two, one);
        return degrees(PVector.angleBetween(limb, axis));
}
//Calibration not required
public void onNewUser(SimpleOpenNI kinect, int userId) {
        println("Start skeleton tracking");
        kinect.startTrackingSkeleton(userId);
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Skeleton_Tracking" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
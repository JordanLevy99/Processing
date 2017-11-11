import SimpleOpenNI.*;
import processing.serial.*;

//Generate a SimpleOpenNI object
SimpleOpenNI kinect;

Serial myPort;  // Create object from Serial class

void setup() {
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// because of the version this change
 size(640, 480);
 fill(255, 0, 0);
 kinect.setMirror(true);

 //Open the serial port
 String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
 myPort = new Serial(this, portName, 9600);

}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {

    int userId = userList.get(0);

    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {

      drawSkeleton(userId);

      // get the positions of the three joints of our right arm
     PVector rightHand = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
     PVector rightElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
     PVector rightShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
     // we need right hip to orient the shoulder angle
     PVector rightHip = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);

     // get the positions of the three joints of our left arm
     PVector leftHand = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
     PVector leftElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,leftElbow);
     PVector leftShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder);
     // we need left hip to orient the shoulder angle
     PVector leftHip = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHip);

     // reduce our joint vectors to two dimensions for right side
     PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
     PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
     PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
     PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
     PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);

     // reduce our joint vectors to two dimensions for left side
     PVector leftHand2D = new PVector(leftHand.x, leftHand.y);
     PVector leftElbow2D = new PVector(leftElbow.x, leftElbow.y);
     PVector leftShoulder2D = new PVector(leftShoulder.x,leftShoulder.y);
     PVector leftHip2D = new PVector(leftHip.x, leftHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoLOrientation = PVector.sub(leftShoulder2D, leftHip2D);
     PVector upperArmLOrientation = PVector.sub(leftElbow2D, leftShoulder2D);

     // calculate the angles between our joints for rightside
     float RightshoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
     float RightelbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
     // show the angles on the screen for debugging
     fill(255,0,0);
     scale(3);
     text("Right shoulder: " + int(RightshoulderAngle) + "\n" + " Right elbow: " + int(RightelbowAngle), 20, 20);

     // calculate the angles between our joints for leftside
     float LeftshoulderAngle = angleOf(leftElbow2D, leftShoulder2D, torsoLOrientation);
     float LeftelbowAngle = angleOf(leftHand2D,rightElbow2D,upperArmLOrientation);
     // show the angles on the screen for debugging
     fill(255,0,0);
     scale(3);
     text("Left shoulder: " + int(LeftshoulderAngle) + "\n" + " Left elbow: " + int(LeftelbowAngle), 20, 20);

     //Here I started to send information to the Arduino

       if (RightelbowAngle >= 50)
        {                           //if we clicked in the window
           myPort.write('1');         //send a 1
           println("1");
        } else
        {                           //otherwise
          myPort.write('0');          //send a 0
          println("0");
        }

    }

  }

}

//Draw the skeleton

void drawSkeleton(int userId) {

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

void drawJoint(int userId, int jointID) {
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Generate the angle
 float angleOf(PVector one, PVector two, PVector axis){
 PVector limb = PVector.sub(two, one);
 return degrees(PVector.angleBetween(limb, axis));
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
#include "ofApp.h"

#define RECONNECT_TIME 400

//--------------------------------------------------------------
void ofApp::setup(){
	// we don't want to be running to fast
	ofSetVerticalSync(true);
	ofSetFrameRate(30);


    //create the socket and set to send to 127.0.0.1:11999
	sender.setup(HOST, PORT);
	setupUDP(HOST, 29095);


}

void ofApp::setupUDP(string _ip, int _port) {

	//create the socket and set to send to 127.0.0.1:11999
	udpConnection.Create();
	udpConnection.Connect(_ip.c_str(), _port);
	udpConnection.SetNonBlocking(true);

}

//--------------------------------------------------------------
void ofApp::update(){

	xPos = (float)ofGetMouseX() / (float)ofGetWidth();
	yPos = (float)ofGetMouseY() / (float)ofGetHeight();

	sendOSCBlobData(xPos, yPos);

}
//-----------------------------------------
void ofApp::sendOSCBlobData(float _xPos, float _yPos) {

	if (true) {

		ofxOscMessage m;
		m.clear();
		m.setAddress("/GameBlob");
		m.addFloatArg(_xPos);
		m.addFloatArg(_yPos);

		// sending float to be able to make more actions filtering in the client.
		//Like Intenisty of the action
		float fUpActionBlob = 0;
		float fDownActionBlob = 0;
		m.addFloatArg(fUpActionBlob);
		m.addFloatArg(fDownActionBlob);

		sender.sendMessage(m, false);
	}

	if (true) {

		string message = "/GameBlob ffff ";
		float fUpActionBlob = 0;
		float fDownActionBlob = 0;
		message = message + ofToString(_xPos, 2) + " " + ofToString(_yPos, 2) + " " + ofToString(fUpActionBlob, 2) + " " + ofToString(fDownActionBlob, 2);
		udpConnection.Send(message.c_str(), message.length());

		cout << "message UDP = " << message << endl;

	}
	//TODO send here other data type
	//for(areas)
	//if(bSendOsc_fMiddleX_fMinY_fUP_fDOWN_Area1)
	//if(bSendOsc_fMiddleX_fMinY_fUP_fDOWN_Area2)
	//...
	//if(bSendOsc_Recognized_MoveMent1)
	//..

}
//--------------------------------------------------------------
void ofApp::draw(){

	ofFill();
	ofSetColor(ofColor::pink);
	ofDrawCircle(ofGetMouseX(), ofGetMouseY(), 30);

	string text2Draw = "x = " + ofToString(xPos, 2) + " y = " + ofToString(yPos, 2);
	ofDrawBitmapStringHighlight(text2Draw, ofGetMouseX(), ofGetMouseY());


}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){


}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

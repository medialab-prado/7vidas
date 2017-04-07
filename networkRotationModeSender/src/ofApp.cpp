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

//-----------------------------------------
void ofApp::sendOSCBlobData(int _id, float _xPos, float _yPos) {

	if (true) {

		ofxOscMessage m;
		m.clear();
		if(_id == 1)m.setAddress("/GameBlob");
		else if(_id == 2)m.setAddress("/GameBlob2");
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

		string message;
		if(_id == 1) message = "/GameBlob ffff ";
		else if(_id == 2) message = "/GameBlob2 ffff ";
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
void ofApp::update(){

	xV2 = (float)ofGetMouseX();
	yV2 = (float)ofGetMouseY();

	ofVec2f v1 = ofVec2f(xV1/(float)ofGetWidth(), yV1/(float)ofGetHeight());
	ofVec2f v2 = ofVec2f(xV2/(float)ofGetWidth(), yV2/(float)ofGetHeight());
	ofVec2f v21 = v2 - v1;
	angle = atan2(v21.y, v21.x);//result = atan2 (y,x) * 180 / PI; to dregrees

	sendOSCBlobData(1, xV1, yV1);
	sendOSCBlobData(2, xV2, yV2);

}


//--------------------------------------------------------------
void ofApp::draw(){

	ofFill();
	ofSetColor(ofColor::pink);
	ofDrawCircle(xV1, yV1, 30);

	ofSetColor(ofColor::green);
	ofDrawCircle(xV2, yV2, 30);


	string text2Draw = "angle = " + ofToString(angle, 2);
	ofDrawBitmapStringHighlight(text2Draw, ofGetMouseX(), ofGetMouseY());

	ofSetColor(ofColor::blue);
	ofDrawLine(xV1, yV1, xV2, yV2);

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if(key == 'a'){
		yV1++;
	}else if(key == 'q'){
		yV1--;
	}
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

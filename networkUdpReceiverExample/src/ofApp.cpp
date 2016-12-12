#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	//we run at 60 fps!
	ofSetVerticalSync(true);
	ofSetFrameRate(60);

    //create the socket and bind to port 11999
	udpConnection.Create();
	udpConnection.Bind(29095);
	udpConnection.SetNonBlocking(true);

	ofSetBackgroundAuto(false);
	ofBackground(255, 255, 255);
}

//--------------------------------------------------------------
void ofApp::update(){

	char udpMessage[100000];
	udpConnection.Receive(udpMessage,100000);
	message=udpMessage;
	if(message!=""){
		cout << "Receiving data  at frame " << ofGetFrameNum() << endl;
	}else{
		//receiving... nothing
	}

}

//--------------------------------------------------------------
void ofApp::draw(){
    ofFill();
    ofSetHexColor(0xFFFFFF);
    ofDrawRectangle(0,0,200,30);
	ofSetHexColor(0x101010);
	ofDrawBitmapString("UDP Receiver Example ", 10, 20);
	ofDrawBitmapStringHighlight(message, 10, 80);
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

#pragma once

#include "ofxNetwork.h"
#include "ofxOsc.h"

#include "ofMain.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();
		
		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);		

		//default pos V1, V2
		float xV1 = 100;
		float yV1 = 100; 
		float xV2 = 300;
		float yV2 = 100;

		float angle = 0;
		//------------------------
		///////////////////////////////
		////OSC

		//Sender
		void setupUDP(string _ip, int _port);
		ofxUDPManager udpConnection;
		void sendOSCBlobData(int id, float _xPos, float _yPos);

		//OSC filterd data
		ofxOscSender sender;

		//OSC CONFIG
		bool bResetHostIp = false;
		int PORT = 12345;
		string HOST = "127.0.0.1";//MLP: "192.168.2.254";
		///////////////////////////////////////
};


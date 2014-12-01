#include "ofMain.h"
#include "ofApp.h"

int main(){
	ofAppiOSWindow * window = new ofAppiOSWindow();
	window->enableRetina();
	window->enableOrientationAnimation();
	window->enableHardwareOrientation();
	
	ofSetupOpenGL(window, 1920, 1080, OF_FULLSCREEN);
	
	ofRunApp(new ofApp());
}

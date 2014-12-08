#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxPd.h"
#include "NamedColors.h"

struct Note {
	Note(int _pitch, int _duration, string _lyric) {
		pitch = _pitch;
		duration = _duration;
		lyric = _lyric;
	};
	
	int pitch, duration;
	string lyric;
};

using namespace pd;

class ofApp : public ofxiOSApp, public PdReceiver {
	public:
		void setup();
		void update();
		void draw();
		void exit();

		void touchDown(ofTouchEventArgs & touch);
		void touchMoved(ofTouchEventArgs & touch);

		void lostFocus();
		void gotFocus();
		void gotMemoryWarning();
		void deviceOrientationChanged(int newOrientation);

		int toMidi(char step, int alter, int octave);
		
		ofXml xml;
		
		ofxPd pd;
		void audioOut(float* output, int bufferSize, int numChannels);
		void audioIn(float* input, int bufferSize, int numChannels);
		void receiveFloat(const std::string& dest, float value);
		
		map<string, int> midiTable;
		ofTrueTypeFont font;
	
		vector<Note> voicePartS;
		vector<Note> voicePartA;
		vector<Note> voicePartT;
		vector<Note> voicePartB;
	
		vector<int> pianoRollS;
		vector<int> pianoRollA;
		vector<int> pianoRollT;
		vector<int> pianoRollB;
		
		float bpm;
		float tempo;
		
		int numTotalNotesS;
		int numTotalNotesA;
		int numTotalNotesT;
		int numTotalNotesB;
	
		int metroBeat;
	
		int currentBeatS;
		int currentBeatA;
		int currentBeatT;
		int currentBeatB;
	
		int currentNoteS;
		int currentNoteA;
		int currentNoteT;
		int currentNoteB;
		
		float voicePitch;
		ofColor voiceColor;
		int noteYPos;
		int difficulty;
	
		int fromFiddle;
	
		bool bIsDone;
		bool bIsStarted;
	
		int sumTenor;

};



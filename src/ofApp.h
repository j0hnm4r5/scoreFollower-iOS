#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxPd.h"
#include "NamedColors.h"

#define NPARTS 4

#define SOPRANO 0
#define ALTO 1
#define TENOR 2
#define BASS 3

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
	
		void pickSong();
		string song;
	
		void drawTitle();
		void drawEnd();

		void touchDown(ofTouchEventArgs & touch);
		void touchMoved(ofTouchEventArgs & touch);
		void touchUp(ofTouchEventArgs & touch);

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
	
		void calibrate();
		int startingNote;
		int noteOffset;
		
		map<string, int> midiTable;
	
		ofTrueTypeFont font;
	
		int voice;
	
		vector<Note>		voicePart[NPARTS];
		vector<int>			pianoRoll[NPARTS];
		vector<string>	lyricRoll[NPARTS];
		
		float		bpm;
		float		tempo;
		int			metroBeat;
	
		int	numTotalNotes[NPARTS];
		int	currentBeat[NPARTS];
		int	currentNote[NPARTS];
		int	currentLyric[NPARTS];
		string lastLyric[NPARTS];
		
		float			voicePitch;
		ofColor		voiceColor;
		int				noteYPos;
	
	
		int	difficulty;
	
		int fromFiddle;
	
		int isDone[4];
		bool bIsStarted;
		bool bIsCalibrating;

};



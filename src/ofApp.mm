#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

	voice = TENOR;
	
	//	MIDI MAP -----
	{
		midiTable["C"]  = 24;
		midiTable["C#"] = 25;
		midiTable["Db"] = 25;
		midiTable["D"]  = 26;
		midiTable["D#"] = 27;
		midiTable["Eb"] = 27;
		midiTable["E"]  = 28;
		midiTable["F"]  = 29;
		midiTable["F#"] = 30;
		midiTable["Gb"] = 30;
		midiTable["G"]  = 31;
		midiTable["G#"] = 32;
		midiTable["Ab"] = 32;
		midiTable["A"]  = 33;
		midiTable["A#"] = 34;
		midiTable["Bb"] = 34;
		midiTable["B"]  = 35;
	}
	
	//	XML SETUP -----
	xml.load("InMyRoom-ScoreFollow.xml");
//	xml.load("twinkle.xml");
	
	char step;
	int alter;
	int octave;
	int duration;
	string lyric;
	int numMeasures;
	
	// create intro beats
	for (int part = 0; part < NPARTS; part++) {
    voicePart[part].push_back(Note(-100, 4, ""));
		numTotalNotes[part]++;
	}
	
	// create song
	xml.setTo("score-partwise");
	for (int part = 0; part < NPARTS; part++) {
		// move into part
    xml.setTo("part");
		numTotalNotes[part] = 0;
		ofLog() << xml.getName();
		
		// for every measure
		numMeasures = xml.getNumChildren();
		for (int measure = 0; measure < numMeasures; measure++) {
		
			// move into measure
			xml.setToChild(measure);
			
			// for every note in the measure
			int numNotes = xml.getNumChildren();
			for (int note = 0; note < numNotes; note++) {
				
				// move into note
				xml.setToChild(note);
				if (xml.getName() == "note") {
				
					// if it's a rest, set to 0
					if (xml.exists("rest")) {
						step = '\n';
						octave = 0;
						alter = 0;
					} else {
						// otherwise, move into pitch
						xml.setTo("pitch");
						{
							// move into, then out of: step
							xml.setTo("step");
							step = ofToChar(xml.getValue());
							xml.setTo("../");
							
							// if it's an accidental
							if (xml.exists("alter")) {
								// move into, then out of alter
								xml.setTo("alter");
								alter = ofToInt(xml.getValue());
								xml.setTo("../");
							} else {
								alter = 0;
							}
							
							// move into, then out of: octave
							xml.setTo("octave");
							octave = ofToInt(xml.getValue());
							xml.setTo("../");
						}
						// move out of pitch
						xml.setTo("../");
						
						// move into lyric
						if (xml.exists("lyric")) {
							xml.setTo("lyric");
							xml.setTo("text");
							lyric = xml.getValue();
							xml.setTo("../../");
						} else {
							lyric = "";
						}
					}
					
					// move into, then out of: duration
					xml.setTo("duration");
					duration = ofToInt(xml.getValue());
					xml.setTo("../");
					
					// add new Note to vector
					ofLog() << step;
					voicePart[part].push_back(Note(toMidi(step, alter, octave), duration, lyric));
					numTotalNotes[part]++;
				}
				// move out of note
				xml.setToParent();
			}
			// move out of measure
			xml.setToParent();
		}
		xml.setToSibling();
		ofLog() << "NEXT VOICE -------------";
	}
	
	// create outro beats
	for (int part = 0; part < NPARTS; part++) {
		for (int i = 0; i < 8; i++) {
			voicePart[part].push_back(Note(-200, 1, ""));
			numTotalNotes[part]++;
		}
	}
	
	//	PD SETUP -----
	int numOutChannels = 2;
	int numInChannels = 1;
	int sampleRate = 44100;
	int ticksPerBuffer = 8;
	
	pd.init(numOutChannels, numInChannels, sampleRate, ticksPerBuffer);
	
	pd.subscribe("pdMetro");
	pd.subscribe("pdFiddle");
	pd.addReceiver(*this);
	
	pd.start();
	pd.openPatch("metronome.pd");
	
	ofSoundStreamSetup(numOutChannels, numInChannels, this, sampleRate, ofxPd::blockSize() * ticksPerBuffer, 1);
	
	// TODO: this is broken; libpd is running metro too slow ---
	bpm = 500;
	tempo = (60 / bpm) * 1000;
	pd.sendFloat("tempo", tempo);
	// ---
	
	for (int part = 0; part < NPARTS; part++) {
    currentBeat[part] = 1;
		currentNote[part] = 0;
		lastLyric[part] = "";
		isDone[part] = 127;
	}
	
	//  PIANOROLL SETUP -----
	for (int col = 0; col < 128; col++) {
		for (int part = 0; part < NPARTS; part++) {
			pianoRoll[part].push_back(0);
		}
	}
	
	// LYRICROLL SETUP -----
	for (int col = 0; col < 128; col++) {
		for (int part = 0; part < NPARTS; part++) {
			lyricRoll[part].push_back("");
		}
	}
	
	//  OF SETUP -----
	ofBackground(midnightBlue);
	ofSetOrientation(OF_ORIENTATION_90_RIGHT);
	
	ofTrueTypeFont::setGlobalDpi(72);
	font.loadFont("verdana.ttf", 30, true, true);
	font.setLineHeight(34.0f);
	font.setLetterSpacing(1.035);
	
	voicePitch = ofGetHeight() / 2;
	difficulty = 5;
	bIsStarted = false;
	bIsCalibrating = false;
	
}

//--------------------------------------------------------------
void ofApp::audioOut(float *output, int bufferSize, int numChannels) {
	pd.audioOut(output, bufferSize, numChannels);
}

//--------------------------------------------------------------
void ofApp::audioIn(float *input, int bufferSize, int numChannels) {
	pd.audioIn(input, bufferSize, numChannels);
}

//--------------------------------------------------------------
void ofApp::receiveFloat(const std::string& dest, float value) {
	
	if (dest == "pdMetro") {
		metroBeat = (int)value;
	}
	
	if (dest == "pdFiddle") {
		fromFiddle = (int)value;
	}
	
}

//--------------------------------------------------------------
int ofApp::toMidi(char step, int alter, int octave) {
	
	string accidental = "";
	
	if (alter == -1) {
		accidental = "b";
	} else if (alter == 1) {
		accidental = "#";
	}
	
	string note = step + accidental;
	
	int midi = midiTable[note];
	midi += (octave - 1) * 12;
	
	return midi;
}

//--------------------------------------------------------------
int convertRange(int val, int oldMin, int oldMax, int newMin, int newMax) {
	return newMin + ((float)(val - oldMin) / (float)(oldMax - oldMin) * newMax - newMin);
}

//--------------------------------------------------------------
void ofApp::update(){
	
	if (metroBeat > 0) {
	
		// this works with a pianoroll, a 128 item long integer array (per part) that contains the midi value of each note. While a note is being "played" it is added to the end of the array, and the item at the front is removed per frame.
		
		// keep the whole roll moving;
		
		for (int part = 0; part < NPARTS; part++) {
			// if song is finished
			if (currentNote[part] == numTotalNotes[part]) {
				pianoRoll[part].erase(pianoRoll[part].begin());
				pianoRoll[part].push_back(-1);
				lyricRoll[part].erase(lyricRoll[part].begin());
				lyricRoll[part].push_back("");
				isDone[part]--;
			} else {
				// add the current note to the end of the pianoroll, and delete the first note
				pianoRoll[part].erase(pianoRoll[part].begin());
				pianoRoll[part].push_back(voicePart[part][currentNote[part]].pitch - noteOffset);
				
				// add the current lyric to the end of the pianoroll, and delete the first lyric. Only show lyric once per note.
				string currentLyric = voicePart[part][currentNote[part]].lyric;
				if (lastLyric[part] != currentLyric) {
					lyricRoll[part].erase(lyricRoll[part].begin());
					lyricRoll[part].push_back(currentLyric);
				} else {
					lyricRoll[part].erase(lyricRoll[part].begin());
					lyricRoll[part].push_back("");
				}
				lastLyric[part] = currentLyric;
				
				// if note has played for full length, move on to the next note
				if (metroBeat - currentBeat[part] >= voicePart[part][currentNote[part]].duration) {
					currentNote[part]++;
					currentBeat[part] = metroBeat;
				}
			}
		}
	}
	
	// send the semitone offsets
	pd.sendFloat("soprano", pianoRoll[SOPRANO][0] - pianoRoll[voice][0]);
	pd.sendFloat("alto", pianoRoll[ALTO][0] - pianoRoll[voice][0]);
	pd.sendFloat("tenor", pianoRoll[TENOR][0] - pianoRoll[voice][0]);
	pd.sendFloat("bass", pianoRoll[BASS][0] - pianoRoll[voice][0]);
	
}

//--------------------------------------------------------------
void ofApp::draw(){
	
	// left third HUD
	ofSetColor(wetAsphalt);
	ofRect(0, 0, ofGetWidth() / 3, ofGetHeight());
	
	int isDoneSum = 0;
	for (int part = 0; part < NPARTS; part++) {
		isDoneSum	 += isDone[part];
	}
	if (isDoneSum > 0) {
		
		int noteHeight;
		ofColor color[4] = {wisteria, orange, silver, pomegranate};
		
		// for all parts but voice
		for (int part = 0; part < NPARTS; part++) {
			if (part != voice) {
				noteHeight = 5;
				ofSetColor(color[part]);
				for (int i = 0; i < 128; i++) {
				
					// set noteYPos
					noteYPos = ofGetHeight() - convertRange(pianoRoll[part][i], 0, 127, 0, ofGetHeight());
					// draw note
					ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, noteHeight);
				}
			}
		}
		
		// for voice
		for (int i = 0; i < 128; i++) {
		ofSetColor(color[voice]);
			noteHeight = 10;
			// set noteYPos
			noteYPos = ofGetHeight() - convertRange(pianoRoll[voice][i], 0, 127, 0, ofGetHeight());
			// draw lyric
			font.drawString(lyricRoll[voice][i], i * 10 + (ofGetWidth() / 3) + 5, noteYPos - 20);
			// draw note
			if (fromFiddle == pianoRoll[voice][i] && i < 20) {
				ofSetColor(emerald);
			}
			ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, noteHeight);
		}
	
	// voicePitch triangle
	ofSetColor(color[voice]);
	voicePitch = ofGetHeight() - convertRange(fromFiddle, 0, 127, 0, ofGetHeight());;
	ofTriangle(ofGetWidth() / 3 + 5, voicePitch, ofGetWidth() / 3 - 20, voicePitch + 20, ofGetWidth() / 3 - 20, voicePitch - 15);
	
	// if the song is over
	} else {
		drawEnd();
	}
	
	// if the song hasn't started yet
	if (bIsStarted == false) {
		drawTitle();
	}
	
	// if we're calibrating
	if (bIsCalibrating == true) {
		calibrate();
	}
	
	
	
//--------------------------------------------------------------
void ofApp::calibrate(){
	noteOffset = voicePart[voice][1].pitch - fromFiddle;
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
	if (bIsStarted == false) {
		bIsCalibrating = true;
	}
	
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
	if (bIsCalibrating == true) {
		bIsCalibrating = false;
		pd.sendFloat("io", 1);
		bIsStarted = true;
	}
}



//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

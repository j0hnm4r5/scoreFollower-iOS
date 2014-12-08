#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	
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
	xml.load("tune.xml");
	
	char step;
	int alter;
	int octave;
	int duration;
	int numMeasures;
	
	// create intro beats
	voicePartS.push_back(Note(0, 4));
	numTotalNotesS++;
	voicePartA.push_back(Note(0, 4));
	numTotalNotesA++;
	voicePartT.push_back(Note(0, 4));
	numTotalNotesT++;
	voicePartB.push_back(Note(0, 4));
	numTotalNotesB++;
	
	// move into soprano
	xml.setTo("part");
	
	numTotalNotesS = 0;
	
	numMeasures = xml.getNumChildren();
	
	// create song
	for (int i = 0; i < numMeasures; i++) {
		
		// move into measure
		xml.setToChild(i);
		
		int numNotes = xml.getNumChildren();
		for (int j = 0; j < numNotes; j++) {
			
			// move into note
			xml.setToChild(j);
			
			if (xml.getName() == "note") {
				
				if (xml.exists("rest")) {
					
					step = 0;
					octave = 0;
					alter = 0;
					
				} else {
					
					// move into pitch
					xml.setTo("pitch");
					
					// move into, then out of step
					xml.setTo("step");
					step = ofToChar(xml.getValue());
					xml.setTo("../");
					
					
					if (xml.exists("alter")) {
						
						// move into, then out of alter
						xml.setTo("alter");
						alter = ofToInt(xml.getValue());
						xml.setTo("../");
						
					} else {
						alter = 0;
					}
					
					// move into, then out of octave
					xml.setTo("octave");
					octave = ofToInt(xml.getValue());
					xml.setTo("../");
					
					// move out of pitch
					xml.setTo("../");
				}
				
				// move into, then out of duration
				xml.setTo("duration");
				duration = ofToInt(xml.getValue());
				xml.setTo("../");
				
				
				// add new Note to vector
				voicePartS.push_back(Note(toMidi(step, alter, octave), duration));
				numTotalNotesS++;
				
			}
			// move out of note
			xml.setToParent();
		}
		// move out of measure
		xml.setToParent();
	}
	
	
	// move into alto
	xml.setToSibling();
	
	numTotalNotesA = 0;
	
	numMeasures = xml.getNumChildren();
	
	// create song
	for (int i = 0; i < numMeasures; i++) {
		
		// move into measure
		xml.setToChild(i);
		
		int numNotes = xml.getNumChildren();
		for (int j = 0; j < numNotes; j++) {
			
			// move into note
			xml.setToChild(j);
			
			if (xml.getName() == "note") {
				
				if (xml.exists("rest")) {
					
					step = 0;
					octave = 0;
					alter = 0;
					
				} else {
					
					// move into pitch
					xml.setTo("pitch");
					
					// move into, then out of step
					xml.setTo("step");
					step = ofToChar(xml.getValue());
					xml.setTo("../");
					
					
					if (xml.exists("alter")) {
						
						// move into, then out of alter
						xml.setTo("alter");
						alter = ofToInt(xml.getValue());
						xml.setTo("../");
						
					} else {
						alter = 0;
					}
					
					// move into, then out of octave
					xml.setTo("octave");
					octave = ofToInt(xml.getValue());
					xml.setTo("../");
					
					// move out of pitch
					xml.setTo("../");
				}
				
				// move into, then out of duration
				xml.setTo("duration");
				duration = ofToInt(xml.getValue());
				xml.setTo("../");
				
				
				// add new Note to vector
				voicePartA.push_back(Note(toMidi(step, alter, octave), duration));
				numTotalNotesA++;
				
			}
			// move out of note
			xml.setToParent();
		}
		// move out of measure
		xml.setToParent();
	}
	
	
	// move into tenor
	xml.setToSibling();
	
	numTotalNotesT = 0;
	
	numMeasures = xml.getNumChildren();
	
	// create song
	for (int i = 0; i < numMeasures; i++) {
		
		// move into measure
		xml.setToChild(i);
		
		int numNotes = xml.getNumChildren();
		for (int j = 0; j < numNotes; j++) {
			
			// move into note
			xml.setToChild(j);
			
			if (xml.getName() == "note") {
				
				if (xml.exists("rest")) {
					
					step = 0;
					octave = 0;
					alter = 0;
					
				} else {
					
					// move into pitch
					xml.setTo("pitch");
					
					// move into, then out of step
					xml.setTo("step");
					step = ofToChar(xml.getValue());
					xml.setTo("../");
					
					
					if (xml.exists("alter")) {
						
						// move into, then out of alter
						xml.setTo("alter");
						alter = ofToInt(xml.getValue());
						xml.setTo("../");
						
					} else {
						alter = 0;
					}
					
					// move into, then out of octave
					xml.setTo("octave");
					octave = ofToInt(xml.getValue());
					xml.setTo("../");
					
					// move out of pitch
					xml.setTo("../");
				}
				
				// move into, then out of duration
				xml.setTo("duration");
				duration = ofToInt(xml.getValue());
				xml.setTo("../");
				
				
				// add new Note to vector
				voicePartT.push_back(Note(toMidi(step, alter, octave), duration));
				numTotalNotesT++;
				
			}
			// move out of note
			xml.setToParent();
		}
		// move out of measure
		xml.setToParent();
	}
	
	
	// move into bass
	xml.setToSibling();
	
	numTotalNotesB = 0;
	
	numMeasures = xml.getNumChildren();
	
	// create song
	for (int i = 0; i < numMeasures; i++) {
		
		// move into measure
		xml.setToChild(i);
		
		int numNotes = xml.getNumChildren();
		for (int j = 0; j < numNotes; j++) {
			
			// move into note
			xml.setToChild(j);
			
			if (xml.getName() == "note") {
				
				if (xml.exists("rest")) {
					
					step = 0;
					octave = 0;
					alter = 0;
					
				} else {
					
					// move into pitch
					xml.setTo("pitch");
					
					// move into, then out of step
					xml.setTo("step");
					step = ofToChar(xml.getValue());
					xml.setTo("../");
					
					
					if (xml.exists("alter")) {
						
						// move into, then out of alter
						xml.setTo("alter");
						alter = ofToInt(xml.getValue());
						xml.setTo("../");
						
					} else {
						alter = 0;
					}
					
					// move into, then out of octave
					xml.setTo("octave");
					octave = ofToInt(xml.getValue());
					xml.setTo("../");
					
					// move out of pitch
					xml.setTo("../");
				}
				
				// move into, then out of duration
				xml.setTo("duration");
				duration = ofToInt(xml.getValue());
				xml.setTo("../");
				
				
				// add new Note to vector
				voicePartB.push_back(Note(toMidi(step, alter, octave), duration));
				numTotalNotesB++;
				
			}
			// move out of note
			xml.setToParent();
		}
		// move out of measure
		xml.setToParent();
	}
	
	
	
	//create outro beats
	voicePartS.push_back(Note(0, 1));
	numTotalNotesS++;
	voicePartA.push_back(Note(0, 1));
	numTotalNotesA++;
	voicePartT.push_back(Note(0, 1));
	numTotalNotesT++;
	voicePartB.push_back(Note(0, 1));
	numTotalNotesB++;
	
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
	bpm = 250;
	tempo = (60 / bpm) * 1000;
	pd.sendFloat("tempo", tempo);
	// ---
	
	currentBeatS = 1;
	currentBeatA = 1;
	currentBeatT = 1;
	currentBeatB = 1;
	
	currentNoteS = 0;
	currentNoteA = 0;
	currentNoteT = 0;
	currentNoteB = 0;
	
	pd.sendFloat("volume", 1);
	
	//  PIANOROLL SETUP -----
	for (int col = 0; col < 128; col++) {
		pianoRollS.push_back(0);
		pianoRollA.push_back(0);
		pianoRollT.push_back(0);
		pianoRollB.push_back(0);
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
	bIsDone = false;
	bIsStarted = false;
	sumTenor = 0;
	
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
		
		pianoRollS.erase(pianoRollS.begin());
		pianoRollS.push_back(voicePartS[currentNoteS].pitch);
		pianoRollA.erase(pianoRollA.begin());
		pianoRollA.push_back(voicePartA[currentNoteA].pitch);
		pianoRollT.erase(pianoRollT.begin());
		pianoRollT.push_back(voicePartT[currentNoteT].pitch);
		pianoRollB.erase(pianoRollB.begin());
		pianoRollB.push_back(voicePartB[currentNoteB].pitch);
		
		// if note has played for full length, go to next note
		if (metroBeat - currentBeatS >= voicePartS[currentNoteS].duration) {
			currentNoteS++;
			currentBeatS = metroBeat;
		}
		if (metroBeat - currentBeatA >= voicePartA[currentNoteA].duration) {
			currentNoteA++;
			currentBeatA = metroBeat;
		}
		if (metroBeat - currentBeatT >= voicePartT[currentNoteT].duration) {
			currentNoteT++;
			currentBeatT = metroBeat;
		}
		if (metroBeat - currentBeatB >= voicePartB[currentNoteB].duration) {
			currentNoteB++;
			currentBeatB= metroBeat;
		}
		
				// if song is finished, make pianoRoll blank
		if (currentNoteS == numTotalNotesS) {
			pianoRollS.erase(pianoRollS.begin());
			pianoRollS.push_back(-1);
		}
		if (currentNoteA == numTotalNotesA) {
			pianoRollA.erase(pianoRollA.begin());
			pianoRollA.push_back(-1);
		}
		if (currentNoteT == numTotalNotesT) {
			pianoRollT.erase(pianoRollT.begin());
			pianoRollT.push_back(-1);
		}
		if (currentNoteB == numTotalNotesB) {
			pianoRollB.erase(pianoRollB.begin());
			pianoRollB.push_back(-1);
		}
		
		if (pianoRollT[0] < 0 && pianoRollT[127] < 0) {
			bIsDone = true;
		}
	}
	
	// send the pitch that's touching the HUD
	pd.sendFloat("pitch", pianoRollT[0]);
	
	pd.sendFloat("soprano", pianoRollS[0] - pianoRollT[0]);
	pd.sendFloat("alto", pianoRollA[0] - pianoRollT[0]);
	pd.sendFloat("tenor", 0);
	pd.sendFloat("bass", pianoRollB[0] - pianoRollT[0]);
	
	
	
	if (pianoRollT[0] > 0 && pianoRollT[0] < 128) {
		pd.sendFloat("volume", 1);
	} else {
		pd.sendFloat("volume", 0);
	}
	
	
	
}

//--------------------------------------------------------------
void ofApp::draw(){
	
		// left third HUD
	ofSetColor(wetAsphalt);
	ofRect(0, 0, ofGetWidth() / 3, ofGetHeight());
	
	// voicePitch triangle
	ofSetColor(voiceColor);
	voicePitch = ofGetHeight() - convertRange(fromFiddle, 0, 127, 0, ofGetHeight());;
	ofTriangle(ofGetWidth() / 3 + 5, voicePitch, ofGetWidth() / 3 - 20, voicePitch + 20, ofGetWidth() / 3 - 20, voicePitch - 15);
	voiceColor = concrete;
	
	
	if (bIsDone == false) {
		
		int i;
		
		// pianoRollS
		ofSetColor(wisteria);
		i = 0;
		for (vector<int>::iterator iter = pianoRollS.begin(); iter != pianoRollS.end(); ++iter) {
			
			noteYPos = ofGetHeight() - convertRange(*iter, 0, 127, 0, ofGetHeight());
			// draw the note
			ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, 5);
			i++;
		}
		
		// pianoRollA
		ofSetColor(orange);
		i = 0;
		for (vector<int>::iterator iter = pianoRollA.begin(); iter != pianoRollA.end(); ++iter) {
			
			noteYPos = ofGetHeight() - convertRange(*iter, 0, 127, 0, ofGetHeight());
			// draw the note
			ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, 5);
			i++;
		}
		
		// pianoRollB
		ofSetColor(pomegranate);
		i = 0;
		for (vector<int>::iterator iter = pianoRollB.begin(); iter != pianoRollB.end(); ++iter) {
			
			noteYPos = ofGetHeight() - convertRange(*iter, 0, 127, 0, ofGetHeight());
			// draw the note
			ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, 5);
			i++;
		}
		
		// pianoRollT
		ofSetColor(silver);
		i = 0;
		sumTenor = 0;
		for (vector<int>::iterator iter = pianoRollT.begin(); iter != pianoRollT.end(); ++iter) {
			
			noteYPos = ofGetHeight() - convertRange(*iter, 0, 127, 0, ofGetHeight());
			if (noteYPos >= ofGetHeight()) {
				noteYPos = ofGetHeight();
			} else if (noteYPos <= 0) {
				noteYPos = 0;
			}
			
			// set note and triangle color
			if (i < 10) {
				if (voicePitch < noteYPos + difficulty && voicePitch > noteYPos - difficulty) {
					ofSetColor(nephritis);
					voiceColor = nephritis;
				} else if (voicePitch < noteYPos + difficulty * 1.5 && voicePitch > noteYPos - difficulty * 1.5) {
					ofSetColor(emerald);
					voiceColor = emerald;
				}
			}
			
			// draw the note
			ofRect(i * 10 + (ofGetWidth() / 3), noteYPos, 10, 10);
			i++;
			sumTenor += noteYPos	;
			ofSetColor(silver);
		}
		
	} else {
		font.drawString("that was beautiful", ofGetWidth() / 2 - font.stringWidth("that was beautiful") / 2, ofGetHeight() / 2 - font.stringHeight("that was beautiful") / 2);
	}
	
	
	if (bIsStarted == false) {
		font.drawString("tap to begin", ofGetWidth() / 2 - font.stringWidth("tap to begin") / 2, ofGetHeight() / 2 - font.stringHeight("tap to begin") / 2);
	}
	
	
	
	
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

	pd.sendFloat("io", 1);
	bIsStarted = true;
	
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

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

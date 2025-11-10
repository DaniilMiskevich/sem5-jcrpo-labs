# Test Plan 

## 1 INTRODUCTION

This document outlines the test strategy, scope, and approach for the TempTune mobile application. TempTune is a combined metronome and tuner app for musicians. The goal of this testing is to verify that the app meets all specified functional and non-functional requirements, providing a reliable and user-friendly experience. This plan is intended for the QA team and developers performing the tests.


## 2 TESTING ITEMS

The following features, derived from the SRS, are the primary objects of testing:

- metronome core functionality (BPM control, tap tempo, visual feedback);

- tuner core functionality (tone generation, frequency/note display, waveform selection);

- preset management (create, save, load, edit, delete);

- sound customization (built-in sounds, import/manage custom sounds);

- synchronization & account (login, sync presets/sounds across devices);

- application settings and navigation flow.


## 3 QUALITY ATTRIBUTES

1. Functionality
    - the app must perform all metronome and tuner functions accurately;
    - all specified features must be implemented and working;
    - the app must not crash, stutter, or drop beats during extended use.

2. Performance
    - metronome clicks and tuner tones must be perceived as instantaneous (target <50ms latency);
    - the UI must render smoothly at 60fps;
    - the app must be intuitive for musicians: key actions (starting metronome, changing BPM) must be quickly accessible.


## 4 RISKS
 
There are several risk regarding the TempTune application:

- risk of metronome beats dropping or stuttering, especially on lower-end devices, rendering the core feature unreliable;

- risk of user presets or custom sounds not syncing correctly or being lost during the sync process;

- risk of latency being too high, making the metronome and tuner unusable for precise timing;

- risk of the app crashing or behaving unexpectedly if storage or network permissions are denied.


## 5 ASPECTS OF TESTING

There are several aspects of the TempTune applicatoin that will be tested.


### 5.1 Metronome Functionality

- adjusting BPM via slider/dial (range: 30-250 BPM);

- using the tap tempo feature to set BPM;

- setting and disabling the accent beat;

- starting and stopping the metronome;

- verifying real-time visual feedback is synchronized with the audio beat;

- verifying the device screen does not lock while the metronome is active.


### 5.2 Tuner Functionality

- generating a stable tone for a selected frequency/note (range: a0 to c8);

- accurately displaying the current frequency and its corresponding note name;

- adjusting the volume of the generated tone independently of system volume;

- switching between different waveform types (sine, square, triangle, sawtooth).


### 5.3 Preset Management

- saving the current metronome configuration (BPM, time signature, accent, sound) as a new preset;

- loading a saved preset and verifying the configuration is applied correctly;

- editing an existing preset's name and configuration;

- deleting a preset.


### 5.4 Sound Customization

- switching between all built-in metronome sounds (e.g., wood block, beep, click);

- importing a custom sound file from device storage (requires permission);

- selecting a custom sound for use in the metronome;

- managing (viewing, deleting) loaded custom sounds.


### 5.5 Synchronization Creating a new account and logging in.

- verifying that presets and custom sounds are uploaded to the cloud upon creation/modification;

- verifying that presets and custom sounds are downloaded and available on a second device after login;

- testing sync behavior in offline mode (queuing changes).


### 5.6 Non-Functional TestingLong

- long session test, running the metronome for more than five minutes to check for crashes, memory leaks, or beat drops;

- verifying that a new user can start the metronome and adjust BPM within 10 seconds.


## 6 TESTING APPROACH

Testing will be primarily manual. A combination of physical devices and emulators/simulators will be used to cover a range of OS versions, screen sizes, and hardware capabilities.


## 7 REPRESENTATION OF RESULTS

Each test case will be recorded with its ID, description, steps, result (Pass/Fail), and any additional notes or bugs found.

There is a separate [Test Results](./test_results.md) document for documenting the result. 


## 8 CONCLUSIONS

This test plan covers the critical functionality of the TempTune app. Successful execution of all tests will provide confidence that the application is stable, performs well, and offers a high-quality user experience for musicians.

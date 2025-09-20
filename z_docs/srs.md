# Requirements Document

## 1 Introduction

This document provides an overview of the requirements for the TempTune mobile app. TempTune is a metronome and tuner application designed to help in musical practice. This document serves as a definitive guide for the development team and will be used for verification and QA upon its completion.


### 1.1 Buisness Requirements

Musicians of all skill levels require precise tools for rhythm and pitch during practice. Many existing solutions are separate apps or physical devices, creating a fragmented experience. Users need to switch between apps or carry physical gear, disrupting their focus and flow state.

There is a clear opportunity for a unified, high-quality application that combines an advanced metronome with an accurate tuner. TempTune will provide a seamless, all-in-one practice toolkit within a single, intuitive and modern UI. By offering unique features like flexible preset configuration, the application will cater to the modern musician's need for efficiency and collaboration, creating a superior user experience that drives adoption and retention.

The TempTune application will provide users with a core metronome functionality, a tone generator for instrument tuning, and the ability to create, save and manage custom presets. Another goal is to implement synchronization of these presets  as well as custom sounds across user deivces. The initial release will not include social features and a comprehensive account system beyond what is required for sync functionality.


### 1.2 Competitive Analysis

Several established apps exist in this space, but they typically excel in one core area - either as a metronome *or* a tuner - but rarely offer a deeply integrated and equally powerful experience for both. TempTune will differentiate itself by providing an integrated toolkit, with a focus on customizable sounds and seamless preset management across devices, which is rerely found in current market offerings.


---


## 2 User Requirements

This section describes the external interfaces, user profiles, and overarching constraints of the TempTune application.


### 2.1 Software Interfaces

The application will interact with the following external systems and libraries:

- Flutter, the core framework for cross-platform development.

- Minisound library. This is the primary audio engine for playing pre-recorded metronome sounds and generating waves for the tuner. This dependency is critical for achieving low-latency audio playback.

- A cloud storage service (Firebase, AWS Amplify, or a custom backend). A service to facilitate the synchronization of user presets across multiple devices. This will handle user authentication, data storage and real-time updates.


### 2.2 User Interfaces

The user interface shall consist of three main screens, navigable via a bottom navigation bar or a main drawer menu:

1. Metronome screen. This is the primary screen featuring a preset selector, a BPM dial/slider, time signature selector, tap tempo button and start/stop controls. Visual feedback will be prominently displayed on the each beat.
![Metronome screen](ui_mockups/metronome_screen.png)

2. Tuner screen. This is the second screen dedicated to the tone generator. It will feature a frequency selector, a volume control and start/stop controls.
![Tuner screen](ui_mockups/tuner_screen.png)

3. Settings screen. This screen hosts account and application settings (e.g. theme), and a button to navigate to the metronome presets and loaded sounds screen.
![Settings screen](ui_mockups/settings_screen.png)

Additinal screens that are navigatable only from on other screens:

4. Presets screen. This is a screen for managing metronome presets (create, view, edit, delete) and loaded sounds.
![Presets screen](ui_mockups/presets_screen.png)


The overall UI shall adhere to modern Material Design 3 (on Android) and Cupertino (on iOS) guidelines, ensuring a native feel on each platform. The design will prioritize clarity, large touch targets, and minimalism to avoid distracting the user during practice or performance.


### 2.3 User Characteristics

Intended users are musicians of all skill levels, across various instruments (guitar, piano, violin, drums, etc.). Users are assumed to have basic familiarity with standard musical terms such as BPM, time signatures and note names. The app must be intuitive enough for a beginner to use effectively without instruction and users are not required to have advanced technical expertise.


### 2.4 Assumptions and Dependencies

The successful implementation of the stated requirements depends on the following factors:

- The app will be unable to synchronize metronome presets without an internet connection and a granted OS permission for the network access.

- The app will be unable to load custom sounds without a granted OS permission for the storage access.


---


## 3 System Requirements



# Use Cases

## 1 Actors

| Actor |                                                         |
|-------|---------------------------------------------------------|
| User  | A person using the application. Presumably, a musician. |


## 2 Usage Variants

### 2.1 Use Metronome for Musical Practice

**Actor:** User

**Preconditions:** App is installed and opened on the **Metronome** screen.

**Main Flow:**
1. User opens the **Metronome** screen.
2. User adjusts the BPM using the slider to their desired tempo.
3. User selects the desired sound.
3. User adjusts the accent beat to a desired value.
4. User presses the **Start** button.
5. System produces a consistent auditory click at the specified tempo.
6. User practices ther instrument along with the metronome.
7. User presses the **Stop** button.

**Alternate Flows:**

- A1: Use Tap Tempo:
    1. User opens the **Metronome** screen.
    2. User taps inside the slider repeatedly to set the BPM instead of using the slider.
    3. The flow continues from the item 3. of the main flow.


### 2.2 Create and Save a Metronome Preset

**Actor:** User

**Preconditions:** App is installed and opened on the **Metronome** screen.

**Main Flow:**
1. User configures the metronome with specific BPM, sound and accent beat.
2. User presses the **Add Preset** button.
3. System displays a dialog for naming the preset.
4. User enters a name and confirms.
5. System saves the current configuration as a named preset.

**Postconditions:** The preset is available for the selection and on the **Presets** screen.


### 2.3 Load a Metronome Preset

**Actor:** User

**Preconditions:** App is installed and opened on the **Metronome** screen. At least one preset has been saved.

**Main Flow:**
1. User selects a preset in the dropdown.
2. System applies all saved settings (BPM, sound, accent beat).

**Postconditions:** The metronome is ready with the settings loaded from a preset.


### 2.4 Tune Instrument

**Actor:** User

**Preconditions:** App is installed and opened on the **Tuner** screen.

**Main Flow:**
1. User opens the **Tuner** screen.
2. User adjusts the frequency using the slider to their desired note.
3. User selects the desired wave type.
4. User adjusts the volume to a desired value.
5. User presses the **Start** button.
6. System generates a continuous sine wave at the selected frequency.
7. User plays the corresponding node on their instrument and adjusts its pitch to match the generated note.
8. User presses the **Stop** button when finished tuning.


### 2.5 Login


### 2.6 Edit or Delete a Metronome Preset


### 2.7 Add a Custom Sound


### 2.8 Edit or Delete a Custom Sound

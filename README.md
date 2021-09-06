# Canvas Matlab Integration
Code to automatically unpack Canvas submissions and unzip student submissions into separate folders. Speeds up grading MATLAB code by allowing the automated opening and running of student files alongside Canvas speedgrader. 

## How it Works
### *reorganize_submissions.m*
This script first creates a roster file from a generic Canvas gradebook CSV file. It then finds the "submissions.zip" file downloaded from Canvas and unzips it. Each student's work is then sorted into respective folders, in the order they appear in the Canvas speedgrader. Any zip files submitted by students are also unpacked and flattened.

### *grade_submissions.m*
This script steps through the resulting submission folder and opens the student .m files for viewing in your MATLAB IDE. It then:

  1. Optionally opens the OS file explorer to provide access to any files in that folder unrelated to MATLAB code (toggle with *open_explorer_flag=true/false*)
  2. Checks to see if there are scripts that can be run. If more than one, it prompts the user to select the script to run. 
  3. Runs the students code before prompting the user to jump to the next student or select a different student to grade. 

## Setup
  1. Download a test zip file of student submissions on canvas to your default download location. 
  2. Download a recent Canvas gradebook as a CSV file and place in this folder. 
  3. Run "reorganize_submissions.m" to create a working folder for Canvas submissions in the Download folder.
  4. If not already done, it is recommended to "dock" scripts to MATLAB IDE using Ctrl+Shift+D.
  5. Run "grade_submissions.m" to run student code alongside Canvas speedgrader.


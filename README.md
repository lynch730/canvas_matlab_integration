# Canvas Matlab Integration
Code to automatically unpack Canvas submissions and unzip student submissions into separate folders. Speeds up grading MATLAB code by allowing the automated opening and running of student files alongside Canvas speedgrader or gradebook. 

## How it Works
### *extract_submissions.m*
This script first creates a roster file from a generic Canvas gradebook CSV file. It then finds the "submissions.zip" file downloaded from Canvas and unzips it. Each student's work is then sorted into respective folders, in the order they appear in the Canvas speedgrader. Any zip files submitted by students are also unpacked and flattened.

### *grade_submissions_manual.m*
This script prompts you for the student folder number, and then opens files for grading.

  1. Optionally opens the OS file explorer to provide access to any files in that folder unrelated to MATLAB code (like PDF, etc) (toggle with *open_explorer_flag=true/false*)
  2. You must rerun grade_submissions_manual.m for each student, and it cannot send you back to the submission folder at the end. 

### *grade_submissions_auto.m*
This script does the manual version, but in a loop where you can step through each student's project one by one. It is more difficult to insert break-points, but can be faster if that is not needed. This script also:

  1. Optionally opens the OS file explorer to provide access to any files in that folder unrelated to MATLAB code (toggle with *open_explorer_flag=true/false*)
  2. Checks to see if there are multiple MATLAB scripts that can be run (excluding functions). If more than one, it prompts the user to select the script to run. 
  3. Runs the students code before prompting the user to jump to the next student or select a different student to grade. 
  
## Setup
  1. Download a test zip file of student submissions on canvas to your default download location. 
  2. Download a recent Canvas gradebook as a CSV file and place in this folder (only supports one section/CSV file). 
  3. Run "extract_submissions.m" to create a working folder for Canvas submissions in the Download folder (Note: this will only grade the generic "submissions.zip" file that canvas downloads).
  4. If not already done, it is recommended to "dock" scripts to MATLAB IDE using Ctrl+Shift+D.
  5. Run "grade_submissions_manual.m" or "grade_submissions_auto.m" to run student code alongside Canvas.


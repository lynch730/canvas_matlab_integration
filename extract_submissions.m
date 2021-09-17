
% This script is meant to automate the processes of unzipping Canvas
% submissions for a particular assignment and preparring/examining student
% code. Roster.mat contains a cell array last_names of students 

% Reset MATLAB
    clear,clc

%% Step (1) - Process submission zip file
    
    % Path to submissions, assuming "submissions.zip" is stored in
    % downloads folder in the same user where MATLAB userpath lives
    spath.root = store_paths;
    
    % If folder exists from previous unzip, delete it
    try
        rmdir(spath.root, 's') 
    catch
        % Do nothing
    end
    
    % Unzip File to this folder
    unzip( [spath.root,'.zip'], spath.root);
    
    % Add filesep to root as standard practice
    spath.root = [spath.root, filesep];
    
    
%% Step (2) - Load Roster from file
    
    % Load Roster (option string of name of MAT file)
    class_roster = get_roster;
    
%% Step (3) - Reorganize into student folders
    
    % Names of sub-folders for sorting student submissions
    spath.unsorted.root = [ spath.root, 'unsorted', filesep ];
    
    % Move files to misc folder 
    movefile( [ spath.root, '*' ], spath.unsorted.root );
    
    % Add Counters to Graded/Ungraded
    spath.count = 0;
    
    % Loop students and extract submissions
    spath = extract_student_submissions( spath, class_roster );
    
%% Step (4) - Save Data
    save( 'submission_state.mat' );
    
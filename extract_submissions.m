
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
    
    
%% Helper Functions
%% --------------------------------------------
%%

%% Function for Extracting individual submissions
    function spath = extract_student_submissions( spath, class_roster )
% extract_student_submissions - Extracts student submissions and processes
% them into a more uniform batch of files. 
   
    % Number of people
    nstudents = size( class_roster, 1 );
    
    % Loop Students, make folder and fill with their submissions
    for i = 1:nstudents
        
        % Student name - shortstring
        last_name  = lower( strtrim( class_roster{i,1} ) );
        first_name = lower( strtrim( class_roster{i,2} ) );
        
         % Print Status
        fprintf('%i/%i, ',[i,nstudents]);
        fprintf('%s, ', last_name);
        fprintf('%s\n', first_name);
        
        % Create path to student folder in ungraded
        temp_path = [ spath.root, num2str(i,'%3i'), '_', ...
                                  last_name,'_', ...
                                  first_name, filesep ];
        
        % Increment Counter in ungraded
        spath.count = spath.count + 1;
        
        % Save path to the student folder
        spath.subfolders{ spath.count,1 } = temp_path;
        
        % Make the student folder
        mkdir( temp_path );
        
        % Check if anything matches this target
        flag = custom_move( [ spath.unsorted.root, last_name, first_name ], temp_path );
        
        % Stop now if not sucessfull
        if ~flag
            
            % unpack student zip files
            unpack_student_zip_files( temp_path );
            
            % Remove any asv files
            delete( [temp_path, '*.asv'] );
            
        end
    
    end
    
    end


%% Unpack any student zip files into a consistent folder
function unpack_student_zip_files( folder ) 
    
    % Get array of zip file flags, names of all the files
    [ idx_zip, fnames ] = check_folder_contents( folder );
    
    % Iterate while any contents are zip files
    while any( idx_zip ) 
        
        % Loop zip files and unzip in place
        for j = find(idx_zip)
            
            % Unzip file in place
            try
                unzip( [ folder, fnames{j} ], folder );
            catch
                warning(['Error in unzipping file: ', folder, fnames{j} ])
            end

            % Remove original zip file
            delete( [ folder, fnames{j} ] );
            
        end
        
        % Get new contents
        [idx_zip, fnames, idx_dir] = check_folder_contents( folder );
        
        %Loop and directories
        for j = find(idx_dir)
            
            % Copy contents to root
            custom_move( [folder, fnames{j}, filesep ],...
                          folder );
            
            % Remove empty folder
            rmdir( [folder, fnames{j}], 's' );
            
        end
        
    end
    
end


%% Check folder for zip files or folders
function [idx_zip, names, idx_dir] = check_folder_contents( folder )
% check_folder_contents - returns boolean arrays for folders/files in a
% folder, indicating whether they are zip files (idx_zip) and/or valid
% (non-hidden) folders (idx_dir)
    
    % Get list of files in a cell array
    files = struct2cell( dir( folder ) ); % Convert to cell array
    
    % Extract file names
    names = files(1,:); % File names from first row
    
    % Boolean test of contains zip ending
    idx_zip = endsWith( names, '.zip' );
    
    % If asked for, 
    idx_dir = [];
    if nargout>2
        
        % Check if isdir
        idx_dir = cell2mat( files(5,:) );
        
        % Exclude hidden directories
        idx_dir( startsWith( names, '.' ) ) = 0; 
        
        % Exclude "__MACOSX" folders (these are just mac hidden files)
        idx_dir( strcmp( names, '__MACOSX' ) ) = 0; 
        
    end
    
end


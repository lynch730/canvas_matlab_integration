function class_roster = get_roster( roster_mat_file )
% get_roster - creates a class_roster cell array with rows = students,
% columns equal to last name and first name (Nx2). This is obtained either
% from the roster.mat file, or if on first pass, the Canvas csv gradebook
% download placed in this folder.

    % Name of roster file, if not given
    if ~exist( 'roster_mat_file', 'var' )
        roster_mat_file = 'roster.mat';
    end
    
    % Add path to the folder where this function lives
    fpath = erase( mfilename('fullpath'), mfilename );
    roster_mat_file = [fpath, roster_mat_file];
    
    % Load Roster MAT file if it exists (Nx2)
    if exist(roster_mat_file,'file')
        
        % Load MAT file
       load(roster_mat_file);
       
       % Throw error if 
       if ~exist('class_roster','var')
          error('Variable named "class_roster" not found in "%s"\n',roster_mat_file); 
       end
       
    else
        
        % Notify user of failure
        fprintf('MAT file "%s" not found',roster_mat_file);
        fprintf(', looking for a .CSV with Canvas gradebook...\n');
        
        % Try creating roster.mat
        try
            
            % Load CSV files
           local_csv_list = dir( fullfile( pwd, '*.csv' ) );
           
           % Act based on number of csv files
           switch numel(local_csv_list)
               case 0
                   warning('No CSV files found in folder');
               case 1
                   % do nothing
               otherwise
                   warning('More than one CSV file in folder!');
           end
           
           % Select and list the CSV folder
           csv_file = local_csv_list(1);
           fprintf('Using CSV File: "%s"...\n',csv_file.name);
           
           % Process Class Roster
           class_roster = process_canvas_csv( csv_file.name );
           fprintf('Roster Processed, saving to MAT file...\n');
           
           % Save roster
           save( roster_mat_file, 'class_roster' );
           fprintf('Saving roster as "%s"...\n',roster_mat_file);
           
        catch % no dice, throw error
           error('Problem encountered prcoessing CSV file'); 
        end
        
    end
        
end

%% Process Canvas CSV Gradebook file
function names = process_canvas_csv( csv_file_name )
    % Reads in csv_file_name in local directory
    % Outputs names as Nx2 with last and first columns respectively. 
    
    % Load in matlab table
    try
       canvas_table = readtable( csv_file_name, 'ReadVariableNames', false );
    catch
        error('Unable to use readtable correctly from %s\n', csv_file_name)
    end
    
    % Process first column for names, split based on comma
    try
       
       % First column names
       names = canvas_table.Var1;

       % Remove erroneous 'student, test' and 'Points Possible'
       names(strcmp(names,'Student'))         = []; 
       names(strcmp(names,'Student, Test'))   = []; 
       names(strcmp(names,'Points Possible')) = [];
       
       % Remove any whitespace in names
       names = strrep(names,' ','');
       
       % Clear any empty cells
       names(cellfun('isempty',names))        = []; 
        
       % Split based on comma delimeter in cavnas file
       names = split(names,',');
       
    catch
       error('Unable to extract names from CSV file properly!'); 
    end
    
    % Spit out roster count for checksum
    fprintf( 'Number of students found: %i\n', size(names,1) );
    
end

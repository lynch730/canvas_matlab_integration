
%% Step 1 - Setup 
    
    % NOTE: You should probably redock before running with Ctrl+Shift+D.
    
    % Reset MATLAB
    clear,clc
    
    % Load submissions file
    load( 'submission_state.mat' );
    
    % Optional add on of opening exploer/nautilis window to see files
    open_explorer_flag = true;
    
    % Change path to this files home
    cd( erase(mfilename('fullpath'), mfilename) );
    
%% Step 2 - Loop Students
    
    % Number of students
    nstudents = size(class_roster,1);
    
    % Get list of files
    files = dir( spath.root );
    
    % Loop while index is in the correct range
    i = 1;
    while i>0 && i<=nstudents
        
        % Open Files in the students folder
        fprintf('%i/%i, ', [i,nstudents]  );
        fprintf('%s, ', class_roster{i,1} );
        fprintf('%s\n', class_roster{i,2} );
        
        % Close files
        close_exclude;
        
        % List of files
        files = dir( spath.subfolders{i} );
        
        % Boolean 
        flags = zeros( numel(files),1 );
        
        % Change folder
        addpath( spath.subfolders{i} )
            
        % Open folder in windows
        if open_explorer_flag 
            update_explorer_window( spath.subfolders{i} );
        end
        
        % Loop files , open if mat file
        for j=1:numel(files)
            
            % File Path 
            file_path = [ files(j).folder, filesep, files(j).name ];
            
            % Check if the file is m file
            if ( exist( file_path ) == 2 && endsWith(file_path,'.m') )
               open( file_path ); 
            end
            
            % Script Type
            flags(j) = local_isfunction( files(j).name );
            
        end
        
        % Find script index
        idx = find( flags==-1, 1 );
        
        % Select index
        if isempty(idx)
            disp('No Script file to run!')
        else
            
            % Create the main file
            probable_main = [files(j).folder, filesep, files(idx).name];
            
            % Create string of file to run
            mfile_to_run = erase(files(idx).name,'.m' );

            % Lock current workspace from 
            save( 'temporary_save_state.mat' );

            % Clear all but name of file to run 
            clearvars -except mfile_to_run temp_state_file; 

            % Run script 
            try
                run( mfile_to_run );
            catch
                fprintf('Error in student submission\n');
            end

            % Reset variables
            clearvars -except mfile_to_run temp_state_file; 
            
            % Load Old file state
            load( 'temporary_save_state.mat' );
            
        end
        
        % Remove folder from path
        rmpath(spath.subfolders{i})
        
        % Wait for input
        dum = input('\nPrompt: enter/-1/index to continue/quit/jump-to: \n');
        
        % Process input as integer or a given index
        if isnumeric(dum)
            if floor(dum)==dum
                i = dum;
            else
                i = i + 1;
            end
        else
            i = i + 1;
        end
        
        % Clear command history
        clc;
        
    end
    
    % Finished Grading
    disp('Finished!')
    
    % Delete Temporary Save State
    delete( 'temporary_save_state.mat' );
    
    
%% Custom close, exclude this script
function close_exclude
    
    % Get array of documents
    m_files_open = matlab.desktop.editor.getAll;
    
    % Close all that are not this file
    for i=1:numel(m_files_open)
        
        % Check if they compare, close if they do not
        if ~contains( m_files_open(i).Filename, mfilename('fullpath') )
            closeNoPrompt( m_files_open(i) );
        end
        
    end
    
end

%% Function to close and open windows explorer window 
function update_explorer_window( folder_to_open )
    
    % Close all open explorer windows
    if ispc
        
        % String for Closing existing explorer windows
        str1 = ['powershell -command "$a = (New-Object -comObject ',...
               'Shell.Application).Windows() | ? { $_.FullName -ne $null} ',...
               '| ? { $_.FullName.toLower().Endswith(''\explorer.exe'') }',...
               ' ; $a | % {  $_.Quit() }"'];
           
        % String for opening explorer window
        str2 = ['explorer.exe ',folder_to_open];
        
    elseif ismac % UNTESTED
        str1 = 'osascript -e ''tell application "Finder" to close windows''';
        str2 = ['open ',folder_to_open];
    elseif isunix
        str1 = 'killall nautilus > /dev/null';
        str2 = ['nautilus "',folder_to_open,'"'];
    else
        error('OS not supported')
    end
    
    % Run Commands
    [~,~] = system(str1);
    system(str2);
    
end


%% Step 1 - Setup 
    
    % NOTE: You should probably redock before running with Ctrl+Shift+D.
    
    % Reset MATLAB
    clear,clc
    
    % Load submissions file
    load( 'submission_state.mat' );
    
    % Optional add on of opening exploer/nautilis window to see files
    open_explorer_flag = true;
    
    % Close files
    close_exclude;
    
     % Open folder in windows
    if open_explorer_flag 
        update_explorer_window( spath.root );
    end
    
%% Select and Open Student Files
    
    % Number of students
    nstudents = size(class_roster,1);
    
    % Print Roster for reference
    fprintf( '\nRoster\n%s\n', repmat('-',1,30) );
    for i = 1:nstudents
        fprintf('%i/%i, ', [i,nstudents]  );
        fprintf('%s, ', class_roster{i,1} );
        fprintf('%s\n', class_roster{i,2} );
    end
    
    %% Ask for student number
    
    % Check input
    flag = false;
    while ~flag
        
        % Attempt Input
        try
            
            % Input Student Folder to Grade
            i = input('\nEnter student folder number to grade:\n ');
            
            % List of student files - this will fail with bad input
            files = dir( spath.subfolders{i} );
            
            % Turn off loop
            flag = true;
            
        catch
            % Do nothing
        end
        
    end
    
    %% Boolean 
    flags = zeros( numel(files),1 );
    
    % Change folder
    cd( spath.subfolders{i} )
    
    % Add the old folder back to the path
    addpath( erase(mfilename('fullpath'), mfilename) );
    
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
        str2 = ['nautilus "',folder_to_open,'" &'];
    else
        error('OS not supported')
    end
    
    % Run Commands
    [~,~] = system(str1);
    [~,~] = system(str2);
    
end

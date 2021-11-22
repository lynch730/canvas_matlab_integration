function spath = store_paths( target_path )
    
    % Get default location for matlab
    if ~exist('target_path','var')
        target_path = userpath;
    end
    
    % Get the root path 
    spath = target_path; 
    spath = spath( 1:strfind(userpath,'Documents')-1 );
    
    
    % Set Zip Extension
    zip_extension = '.zip';
    
    % Point to an unzipped folder called "submissions"
    spath = [spath, 'Downloads', filesep, '*', zip_extension ];
    
    % User Select Zip File to Extract
    [fname,pname] = uigetfile( spath, 'Select Submissions ZIP File to Grade');
    
    % Check errors
    if isnumeric(fname) || isnumeric(pname)
       error('No ZIP file selected') 
    end
                            
    % Fill Out Path
    spath = [ pname, erase(fname,zip_extension) ];
    
end


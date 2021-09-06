function spath = store_paths( target_path )
    
    % Get default location for matlab
    if ~exist('target_path','var')
        target_path = userpath;
    end
    
    % Get the root path 
    spath = target_path; 
    spath = spath( 1:strfind(userpath,'Documents')-1 );
    
    % Point to an unzipped folder called "submissions"
    spath = [spath, 'Downloads', filesep, 'submissions'];
    
end


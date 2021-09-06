function fail_flag = custom_move( source, destination )
%custom_move - OS flexible move file with null supression, but using faster
%system command. output is the status of the system command (0=success).
%All sources are concatenated with a wildcard
    
    % Default to failure
    fail_flag = true;
    
    % OS - Specific Commands
    if ~ispc % Linux or max
        str1 =  ['VAR=','"',source,'" && mv '];
        str2 = ' > /dev/null';
        source2      = ['"$VAR"* '];
        destination2 = ['"', destination,'"'];
    else % PC
        str1 = 'move ';
        str2 = ' > NUL';      
        source2      = ['"', source     ,'*"'];
        destination2 = ['"', destination,'"'];
    end
    
    % Check if files exists
    if ~isempty( dir( [source,'*'] ) )
        
        % Create Command String
        command_string = [str1, source2, ' ', destination2, str2 ];
        
        % Issue Command
        status = system( command_string );
        
        % Adjust for normal flag
        if status==0
           fail_flag = false; 
        else
            fprintf('\tError in copying files in: %s\n',source2);
        end
        
    else % No file failure
        fprintf('\tNo files to copy in %s\n',source);
    end
    
end


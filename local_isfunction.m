function ID = local_isfunction(FUNNAME)
    
    try    
        nargin(FUNNAME) ; % nargin errors when FUNNAME is not a function
        ID = 1  + isa(FUNNAME, 'function_handle') ; % 1 for m-file, 2 for handle
    catch ME
        % catch the error of nargin
        switch (ME.identifier)        
            case 'MATLAB:nargin:isScript'
                ID = -1 ; % script
            case 'MATLAB:narginout:notValidMfile'
                ID = -2 ; % probably another type of file, or it does not exist
            case 'MATLAB:narginout:functionDoesnotExist'
                ID = -3 ; % probably a handle, but not to a function
            case 'MATLAB:narginout:BadInput'
                ID = -4 ; % probably a variable or an array
            otherwise
                ID = 0 ; % unknown cause for error
        end
    end
    
end


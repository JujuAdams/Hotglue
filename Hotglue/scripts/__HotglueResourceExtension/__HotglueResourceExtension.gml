// Feather disable all

/// @param resourceStruct

function __HotglueResourceExtension(_resourceStruct) : __HotglueResourceCommon(_resourceStruct) constructor
{
    static resourceType = "extension";
    
    static __GetFiles = function(_project, _array = [])
    {
        //Copy everything inside the directory
        var _matchAllMask = (os_type == os_windows)? "*.*" : "*";
        
        var _projectDirectory = filename_dir(_project.__projectPath) + "/";
        
        var _directoryArray = [filename_dir(data.path) + "/"];
        while(array_length(_directoryArray) > 0)
        {
            var _directory = array_pop(_directoryArray);
            
            var _file = undefined;
            while(true)
            {
                //On Linux the attribute argument is ignored, and everything that we can read is returned (even directories with a proper pattern).
                //This doesn't affect this function in particular but good to keep that in mind.
                _file = (_file == undefined)? file_find_first(_projectDirectory + _directory + _matchAllMask, fa_directory) : file_find_next();
                if (_file == "") break;
                
                if (directory_exists(_directory + _file))
                {
                    //Process this directory
                    array_push(_directoryArray, _directory + _file + "/");
                }
                else
                {
                    array_push(_array, _directory + _file);
                }
            }
            
            file_find_close();
        }
        
        return _array;
    }
}
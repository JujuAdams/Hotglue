// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelDirectory(_name, _url, _protected) : __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __type = HOTGLUE_CHANNEL_DIRECTORY;
    
    
    
    static Refresh = function(_callback)
    {
        __HotglueTrace($"Refreshing directory \"{__url}\", please wait...");
        
        __refreshCallback = _callback;
        
        call_later(1, time_source_units_frames, function()
        {
            if (is_callable(__refreshCallback))
            {
                __refreshCallback(self, true);
            }
        });
        
        var _array = [];
        var _folderArray = [];
        
        //Copy everything inside the directory
        var _matchAllMask = (os_type == os_windows)? "*.*" : "*";
        
        var _directoryArray = [filename_dir(__url) + "/"];
        while(array_length(_directoryArray) > 0)
        {
            var _directory = array_pop(_directoryArray);
            
            var _foundYYP = false;
            array_resize(_folderArray, 0);
            
            var _file = undefined;
            while(true)
            {
                //On Linux the attribute argument is ignored, and everything that we can read is returned (even directories with a proper pattern).
                //This doesn't affect this function in particular but good to keep that in mind.
                _file = (_file == undefined)? file_find_first(_directory + _matchAllMask, fa_directory) : file_find_next();
                if (_file == "") break;
                
                var _path = _directory + _file;
                if (directory_exists(_path))
                {
                    if (_file != ".git")
                    {
                        //Process this directory
                        array_push(_folderArray, _path + "/");
                    }
                }
                else
                {
                    var _extension = filename_ext(_file);
                    if (_extension == ".yyp")
                    {
                        array_push(_array, _path);
                        _foundYYP = true;
                    }
                    else if ((_extension == ".yyz") || (_extension == ".yymps"))
                    {
                        array_push(_array, _path);
                    }
                }
            }
            
            if (not _foundYYP)
            {
                array_copy(_directoryArray, array_length(_directoryArray), _folderArray, 0, array_length(_folderArray));
            }
            
            file_find_close();
        }
        
        __HotglueTrace($"Finished refreshing directory \"{__url}\"");
        
        DeserializeURLArray(_array);
    }
}
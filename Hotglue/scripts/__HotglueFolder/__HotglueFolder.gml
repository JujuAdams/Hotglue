// Feather disable all

/// @param folderStruct

function __HotglueFolder(_folderStruct) : __HotglueClassAssetCommon() constructor
{
    static _system = __HotglueSystem();
    static type = "folder";
    
    var _path = __HotglueProcessFolderPath(_folderStruct.folderPath);
    __pid = $"folder:{_path}"
    data = _folderStruct;
    __friendlyPath = _path;
    
    static GetPID = function()
    {
        return __pid;
    }
    
    static GetPath = function()
    {
        return __friendlyPath;
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Sanitize
        var _path = string_replace_all(__friendlyPath, "\\", "/");
        
        //Iterate over every stage in the path to ensure we have all the folders set up along the path
        repeat(string_count("/", _path))
        {
            _path = filename_dir(_path);
            
            var _assetPID = $"folder:{_path}";
            if (not variable_struct_exists(_visitedDict, _assetPID))
            {
                array_push(_visitedArray, _assetPID);
                _visitedDict[$ _assetPID] = true;
            }
        }
    }
    
    static __DeleteFromDisk = function(_project)
    {
        //Do nothing!
    }
    
    //static GetName = function()
    //{
    //    return filename_name(__friendlyPath);
    //}
    
    static __GetFiles = function(_project, _array = [])
    {
        //Do nothing
        
        return _array;
    }
    
    static __Copy = function(_destinationProject, _sourceProject)
    {
        //Do nothing!
    }
    
    static __FixYYReferences = function(_project, _subfolder)
    {
        //Do nothing!
    }
    
    static __GetYYPInsertString = function(_subfolder)
    {
        var _folderName = data.name;
        var _folderPath = data.folderPath;
        
        return $"    \{\"$GMFolder\":\"\",\"%Name\":\"{_folderName}\",\"folderPath\":\"{_folderPath}\",\"name\":\"{_folderName}\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",\},\n";
    }
    
    static __InsertIntoYYP = function(_project, _subfolder)
    {
        var _yypString = _project.__yypString;
        
        var _substring = "  \"Folders\":[";
        var _pos = string_pos(_substring, _yypString);
        _pos += string_length(_substring);
        
        if (string_char_at(_yypString, _pos) == "]")
        {
            _yypString = string_insert("\n  ", _yypString, _pos);
        }
        
        if (string_char_at(_yypString, _pos) == "\r")
        {
            ++_pos;
        }
        
        if (string_char_at(_yypString, _pos) == "\n")
        {
            ++_pos;
        }
        
        if (_subfolder != "")
        {
            var _folderPath = __HotglueProcessFolderPath(data.folderPath);
            if (_folderPath == "")
            {
                //The root becomes the same as the subfolder itself. No need to add us to the .yyp
                return;
            }
            else
            {
                var _comparison = string_copy(_subfolder + "/", 1, string_length(_folderPath) + 1);
                if (_comparison != _folderPath + "/")
                {
                    name = $"folder:{_subfolder}/{_folderPath}";
                    _folderPath = $"folders/{_subfolder}/{_folderPath}.yy";
                    data.folderPath = _folderPath;
                }
            }
        }
        
        _project.__yypString = string_insert(__GetYYPInsertString(), _yypString, _pos);
    }
}
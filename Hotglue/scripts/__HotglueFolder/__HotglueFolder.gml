// Feather disable all

/// @param folderStruct

function __HotglueFolder(_folderStruct) constructor
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
        
        var _folderName = data.name;
        var _folderPath = data.folderPath;
        
        if (_subfolder != "")
        {
            _folderPath = __HotglueProcessFolderPath(_folderPath);
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
        
        var _insertString = $"    \{\"$GMFolder\":\"\",\"%Name\":\"{_folderName}\",\"folderPath\":\"{_folderPath}\",\"name\":\"{_folderName}\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",\},\n";
        _project.__yypString = string_insert(_insertString, _yypString, _pos);
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}
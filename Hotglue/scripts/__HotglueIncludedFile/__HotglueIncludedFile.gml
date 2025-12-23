// Feather disable all

/// @param includedFileStruct

function __HotglueIncludedFile(_includedFileStruct) : __HotglueClassAssetCommon() constructor
{
    static _system = __HotglueSystem();
    static type = "included file";
    
    var _includedFileName = _includedFileStruct.filePath + "/" + _includedFileStruct.name;
    path = _includedFileName;
    
    if (string_copy(_includedFileName, 1, 10) == "datafiles/")
    {
        _includedFileName = string_delete(_includedFileName, 1, 10);
    }
    
    __pid = $"included:{_includedFileName}";
    data  = _includedFileStruct;
    
    static GetPID = function()
    {
        return __pid;
    }
    
    static GetPath = function()
    {
        return path;
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
    
    static __DeleteFromDisk = function(_project)
    {
        __HotglueTrace($"Deleting {_project.__projectDirectory + path}");
        file_delete(_project.__projectDirectory + path);
    }
    
    //static GetName = function()
    //{
    //    return data.name;
    //}
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, path);
        
        return _array;
    }
    
    static __Copy = function(_destinationProject, _sourceProject)
    {
        var _destinationPath = _destinationProject.__projectDirectory + path;
        var _sourcePath = _sourceProject.__projectDirectory + path;
        file_copy(_sourcePath, _destinationPath);
    }
    
    static __FixYYReferences = function(_project, _subfolder)
    {
        //Do nothing!
    }
    
    static __GetYYPInsertString = function()
    {
        var _includedFileName = data.name;
        var _includedFilePath = data.filePath;
        
        return $"    \{\"$GMIncludedFile\":\"\",\"%Name\":\"{_includedFileName}\",\"CopyToMask\":-1,\"filePath\":\"{_includedFilePath}\",\"name\":\"{_includedFileName}\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",\},\n";
    }
    
    static __InsertIntoYYP = function(_project, _subfolder_UNUSED)
    {
        var _yypString = _project.__yypString;
        
        var _substring = "  \"IncludedFiles\":[";
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
        
        _project.__yypString = string_insert(__GetYYPInsertString(), _yypString, _pos);
    }
}
// Feather disable all

/// @param includedFileStruct

function __HotglueIncludedFile(_includedFileStruct) constructor
{
    static _system = __HotglueSystem();
    static type = "included file";
    
    var _includedFileName = _includedFileStruct.filePath + "/" + _includedFileStruct.name;
    if (string_copy(_includedFileName, 1, 10) == "datafiles/")
    {
        _includedFileName = string_delete(_includedFileName, 1, 10);
    }
    
    name = $"included:{_includedFileName}";
    data = _includedFileStruct;
    
    static __GetFiles = function(_project, _array = [])
    {
        array_push(_array, data.filePath + "/" + data.name);
        
        return _array;
    }
    
    static __Copy = function(_destinationProject, _sourceProject)
    {
        var _destinationPath = _destinationProject.__projectDirectory + data.filePath + "/" + data.name;
        var _sourcePath = _sourceProject.__projectDirectory + data.filePath + "/" + data.name;
        file_copy(_sourcePath, _destinationPath);
    }
    
    static __FixYYReferences = function(_project, _subfolder)
    {
        //Do nothing!
    }
    
    static __InsertIntoYYP = function(_project)
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
        
        var _includedFileName = data.name;
        var _includedFilePath = data.filePath;
        
        var _insertString = $"    \{\"$GMIncludedFile\":\"\",\"%Name\":\"{_includedFileName}\",\"CopyToMask\":-1,\"filePath\":\"{_includedFilePath}\",\"name\":\"{_includedFileName}\",\"resourceType\":\"GMIncludedFile\",\"resourceVersion\":\"2.0\",\},\n"
        _project.__yypString = string_insert(_insertString, _yypString, _pos);
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}
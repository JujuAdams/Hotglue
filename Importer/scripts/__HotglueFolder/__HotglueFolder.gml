// Feather disable all

/// @param folderStruct

function __HotglueFolder(_folderStruct) constructor
{
    static _system = __HotglueSystem();
    static type = "folder";
    static implemented = true;
    
    name = $"folder:{__HotglueProcessFolderPath(_folderStruct.folderPath)}"
    data = _folderStruct;
    
    static __VerifyFileUnzipped = function(_projectDirectory, _emptyBuffer)
    {
        //Do nothing!
    }
    
    static __Copy = function(_sourceProjectPath, _destinationProjectPath)
    {
        //Do nothing!
    }
    
    static __FixYYReferences = function(_project)
    {
        //Do nothing!
    }
    
    static __InsertIntoYYP = function(_project)
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
        
        var _insertString = $"    \{\"$GMFolder\":\"\",\"%Name\":\"{_folderName}\",\"folderPath\":\"{_folderPath}\",\"name\":\"{_folderName}\",\"resourceType\":\"GMFolder\",\"resourceVersion\":\"2.0\",\},\n";
        _project.__yypString = string_insert(_insertString, _yypString, _pos);
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
}
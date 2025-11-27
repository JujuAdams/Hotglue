// Feather disable all

function __HotglueResourceCommon(_resourceStruct) constructor
{
    static _system = __HotglueSystem();
    static type = "resource";
    
    name = $"resource:{_resourceStruct.name}";
    data = _resourceStruct;
    
    static __VerifyFileUnzipped = function(_projectDirectory, _emptyBuffer)
    {
        //TODO
    }
    
    static __Copy = function(_sourceProjectDirectory, _destinationProjectDirectory)
    {
        var _relativeDirectory = filename_dir(data.path);
        var _destinationDirectory = _destinationProjectDirectory + _relativeDirectory + "/";
        var _sourceDirectory = _sourceProjectDirectory + _relativeDirectory + "/";
        
        if (_system.__destructiveCopy)
        {
            directory_destroy(_destinationDirectory);
        }
        
        directory_create(_destinationDirectory);
        
        return __CopySpecific(_destinationDirectory, _sourceDirectory);
    }
    
    static __FixYYReferences = function(_project)
    {
        var _absolutePath = filename_dir(_project.__projectPath) + "/" + data.path;
        
        var _buffer = buffer_load(_absolutePath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = json_parse(_string);
        var _parentPath = _json.parent.path;
        var _parentName = _json.parent.name;
        
        var _parentFolder = __HotglueProcessFolderPath(_parentPath);
        if (_parentFolder == "")
        {
            //We'll always need to replace the parent folder for assets in the root
            
            var _newName = _project.__yypJson.name;
            var _newPath = $"{_project.__yypJson.name}.yyp";
            
            _string = string_replace_all(_string, $"    \"name\":\"{_parentName}\"", $"    \"name\":\"{_newName}\"");
            _string = string_replace_all(_string, $"    \"path\":\"{_parentPath}\"", $"    \"path\":\"{_newPath}\"");
            
            var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, _string);
            buffer_save(_buffer, _absolutePath);
            buffer_delete(_buffer);
        }
        else
        {
            //Ensure the folder path exists
            _project.EnsureFolderPath(_parentFolder);
        }
    }
    
    static __InsertIntoYYP = function(_project)
    {
        var _yypString = _project.__yypString;
        
        var _substring = "  \"resources\":[";
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
        
        var _insertString = $"    \{\"id\":\{\"name\":\"{data.name}\",\"path\":\"{data.path}\",},},\n";
        _project.__yypString = string_insert(_insertString, _yypString, _pos);
    }
}
// Feather disable all

function __HotglueResourceCommon(_resourceStruct) : __HotglueClassAssetCommon() constructor
{
    static _system = __HotglueSystem();
    static type = "resource";
    
    __pid = $"resource:{_resourceStruct.name}";
    data  = _resourceStruct;
    
    static GetPID = function()
    {
        return __pid;
    }
    
    static GetPath = function()
    {
        return data.path;
    }
    
    static __DeleteFromDisk = function(_project)
    {
        var _directory = filename_dir(_project.__projectDirectory + data.path);
        __HotglueTrace($"Deleting {_directory}");
        directory_destroy(_directory);
    }
    
    static __GetExpandedAssets = function(_project, _visitedArray, _visitedDict)
    {
        var _parentPath = __GetYYJSON(_project).parent.path;
        _parentPath = __HotglueProcessFolderPath(_parentPath);
        
        if (_parentPath != "")
        {
            //Sanitize
            var _parentPath = string_replace_all(_parentPath, "\\", "/");
            
            //Iterate over every stage in the path to ensure we have all the folders set up along the path
            repeat(string_count("/", _parentPath) + 1)
            {
                var _assetPID = $"folder:{_parentPath}";
                if (not variable_struct_exists(_visitedDict, _assetPID))
                {
                    array_push(_visitedArray, _assetPID);
                    _visitedDict[$ _assetPID] = true;
                }
                
                _parentPath = filename_dir(_parentPath);
            }
        }
        
        __GetExpandedAssetsSpecial(_project, _visitedArray, _visitedDict);
    }
    
    static __GetExpandedAssetsSpecial = function(_project, _visitedArray, _visitedDict)
    {
        //Do nothing!
    }
    
    //static GetName = function()
    //{
    //    return data.name;
    //}
    
    static __GetYYJSON = function(_project)
    {
        var _buffer = buffer_load(_project.__projectDirectory + data.path);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        return json_parse(_string);
    }
    
    static __Copy = function(_destinationProject, _sourceProject)
    {
        var _destinationDirectory = _destinationProject.__projectDirectory + filename_dir(data.path) + "/";
        
        if (_system.__destructiveCopy)
        {
            directory_destroy(_destinationDirectory);
        }
        
        directory_create(_destinationDirectory);
        
        __HotglueCopyRelativePathArray(_destinationProject.__projectDirectory, _sourceProject.__projectDirectory, __GetFiles(_sourceProject));
    }
    
    static __FixYYReferences = function(_project, _subfolder)
    {
        var _absolutePath = _project.__projectDirectory + data.path;
        
        var _buffer = buffer_load(_project.__projectDirectory + data.path);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json =  json_parse(_string);
        var _jsonParentPath = _json.parent.path;
        var _jsonParentName = _json.parent.name;
        
        var _parentPath = __HotglueProcessFolderPath(_jsonParentPath);
        
        if ((_subfolder != "") && (resourceType != "ui layer")) //UI layers are always stored in the root
        {
            _parentPath = $"{_subfolder}/{_parentPath}";
            
            var _newName = filename_name(_parentPath);
            var _newPath = $"folders/{_parentPath}.yy";
            
            _string = string_replace_all(_string, $"    \"name\":\"{_jsonParentName}\"", $"    \"name\":\"{_newName}\"");
            _string = string_replace_all(_string, $"    \"path\":\"{_jsonParentPath}\"", $"    \"path\":\"{_newPath}\"");
            
            var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, _string);
            buffer_save(_buffer, _absolutePath);
            buffer_delete(_buffer);
        }
        else
        {
            if (_parentPath == "")
            {
                //We'll always need to replace the parent folder for assets in the root
                
                var _newName = _project.__yypJson.name;
                var _newPath = $"{_project.__yypJson.name}.yyp";
                
                _string = string_replace_all(_string, $"    \"name\":\"{_jsonParentName}\"", $"    \"name\":\"{_newName}\"");
                _string = string_replace_all(_string, $"    \"path\":\"{_jsonParentPath}\"", $"    \"path\":\"{_newPath}\"");
                
                var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
                buffer_write(_buffer, buffer_text, _string);
                buffer_save(_buffer, _absolutePath);
                buffer_delete(_buffer);
            }
        }
    }
    
    static __GetYYPInsertString = function()
    {
        return $"    \{\"id\":\{\"name\":\"{data.name}\",\"path\":\"{data.path}\",},},\n";
    }
    
    static __InsertIntoYYP = function(_project, _subfolder_UNUSED)
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
        
        _project.__yypString = string_insert(__GetYYPInsertString(), _yypString, _pos);
    }
}
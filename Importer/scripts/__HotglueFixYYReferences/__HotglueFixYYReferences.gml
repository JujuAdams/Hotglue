// Feather disable all

/// @param project
/// @param hotglueAsset

function __HotglueFixYYReferences(_project, _hotglueAsset)
{
    static _system = __HotglueSystem();
    
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    var _projectDirectory = filename_dir(_project.__projectPath) + "/";
    
    var _hotglueType = _hotglueAsset.type;
    if (_hotglueType == "resource")
    {
        var _relativePath = _hotglueAsset.data.path;
        var _absolutePath = _projectDirectory + _relativePath;
        
        var _buffer = buffer_load(_absolutePath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = json_parse(_string);
        var _parentPath = _json.parent.path;
        var _parentName = _json.parent.name;
        
        var _parentFolder = __HotglueProcessFolderPath(_parentPath);
        if (_parentFolder == "<root>")
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
    else
    {
        //Do nothing!
    }
}
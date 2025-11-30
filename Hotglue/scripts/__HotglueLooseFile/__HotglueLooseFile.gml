// Feather disable all

/// @param path

function __HotglueLooseFile(_path) constructor
{
    __path = _path;
    
    __name = undefined;
    __type = GetRecommendedType();
    
    
    
    static GetPath = function()
    {
        return __path;
    }
    
    static GetName = function()
    {
        return __name ?? GetOriginalName();
    }
    static SetName = function(_name)
    {
        if (_name != __name)
        {
            __name = (_name == GetOriginalName())? undefined : _name;
        }
    }
    
    static GetOriginalName = function()
    {
        return (__type == "included file")? filename_name(__path) : HotglueSanitizeResourceName(filename_name(__path));
    }
    
    static ResetName = function()
    {
        __name = undefined;
    }
    
    static GetAssetName = function()
    {
        return (__type == "included file")? $"included:{GetName()}" : $"resource:{GetName()}"
    }
    
    static SetType = function(_type)
    {
        if (_type != __type)
        {
            if (__name != undefined)
            {
                if (_type == "included file")
                {
                    __name = filename_change_ext(__name, filename_ext(__path));
                }
                else
                {
                    __name = HotglueSanitizeResourceName(__name);
                }
            }
            
            __type = _type;
        }
    }
    
    static GetType = function()
    {
        return __type;
    }
    
    static GetRecommendedType = function()
    {
        var _extension = filename_ext(__path);
        if (_extension == ".gml")
        {
            return "script";
        }
        else if ((_extension == ".wav")
             ||  (_extension == ".wave")
             ||  (_extension == ".ogg")
             ||  (_extension == ".mp3"))
        {
            return "sound";
        }
        else if ((_extension == ".gif")
             ||  (_extension == ".png")
             ||  (_extension == ".jpg")
             ||  (_extension == ".jpeg")
             ||  (_extension == ".bmp"))
        {
            return "sprite";
        }
        else if (_extension == ".md")
        {
            return "note";
        }
        
        return "included file";
    }
    
    static __GenerateAsset = function(_project)
    {
        if (__type == "included file")
        {
            return new __HotglueIncludedFile({
                name: GetName(),
                filePath: "datafiles",
            });
        }
        else
        {
            
            var _data = {
                name: GetName(),
            };
            
            if (__type == "script")
            {
                _data.path = $"scripts/{GetName()}/{GetName()}.yy";
                return new __HotglueResourceScript(_data);
            }
            else if (__type == "sound")
            {
                _data.path = $"sounds/{GetName()}/{GetName()}.yy";
                return new __HotglueResourceSound(_data);
            }
            else if (__type == "sprite")
            {
                _data.path = $"sprites/{GetName()}/{GetName()}.yy";
                return new __HotglueResourceSprite(_data);
            }
            else if (__type == "note")
            {
                _data.path = $"notes/{GetName()}/{GetName()}.yy";
                return new __HotglueResourceNote(_data);
            }
            else
            {
                __HotglueError($"Unhandled type \"{__type}\"");
            }
        }
    }
    
    static __CreateFilesOnDisk = function(_project, _asset, _subfolder = "")
    {
        if (is_instanceof(_asset, __HotglueIncludedFile))
        {
            file_copy(__path, $"{_project.__projectDirectory}datafiles/{GetName()}");
        }
        else
        {
            if (is_instanceof(_asset, __HotglueResourceScript))
            {
                var _directory = $"{_project.__projectDirectory}scripts/{GetName()}/";
                
                file_copy(__path, $"{_directory}/{GetName()}.gml");
                
                var _buffer = buffer_load("template_script.yy");
                var _templateString = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
            }
            else if (is_instanceof(_asset, __HotglueResourceSound))
            {
                var _directory = $"{_project.__projectDirectory}sounds/{GetName()}/";
                var _soundFilename = filename_change_ext(GetName(), filename_ext(__path));
                
                file_copy(__path, $"{_directory}/{_soundFilename}");
                
                var _buffer = buffer_load("template_sound.yy");
                var _templateString = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                _templateString = string_replace_all(_templateString, "{soundFilename}", _soundFilename);
            }
            else if (is_instanceof(_asset, __HotglueResourceSprite))
            {
                var _directory = $"{_project.__projectDirectory}sprites/{GetName()}/";
                
                var _frameUUID    = "3a612cab-2a59-4a09-a094-8b3205cfda42";
                var _layerUUID    = "3a612cbb-2a59-4a09-a094-8b3205cfda42";
                var _seqFrameUUID = "3a612ccb-2a59-4a09-a094-8b3205cfda42";
                
                file_copy(__path, $"{_directory}/{_frameUUID}.png");
                file_copy(__path, $"{_directory}/layers/{_frameUUID}/{_layerUUID}.png");
                
                var _buffer = buffer_load("template_sprite.yy");
                var _templateString = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                _templateString = string_replace_all(_templateString, "{frameUUID}", _frameUUID);
                _templateString = string_replace_all(_templateString, "{layerUUID}", _layerUUID);
                _templateString = string_replace_all(_templateString, "{seqFrameUUID}", _seqFrameUUID);
            }
            else if (is_instanceof(_asset, __HotglueResourceNote))
            {
                var _directory = $"{_project.__projectDirectory}notes/{GetName()}/";
                
                file_copy(__path, $"{_directory}/{GetName()}.txt");
                
                var _buffer = buffer_load("template_note.yy");
                var _templateString = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
            }
            else
            {
                __HotglueError($"Unhandled asset constructor \"{instanceof(_asset)}\"");
            }
            
            if (_subfolder == "")
            {
                var _parentName = _project.GetName();
                var _parentPath = $"{_project.GetName()}.yyp";
            }
            else
            {
                var _parentName = $"folders/{_subfolder}/";
                var _parentPath = $"{filename_name(_subfolder)}.yy";
            }
            
            _templateString = string_replace_all(_templateString, "{resourceName}", GetName());
            _templateString = string_replace_all(_templateString, "{folderName}", _parentName);
            _templateString = string_replace_all(_templateString, "{folderPath}", _parentPath);
            
            var _buffer = buffer_create(string_byte_length(_templateString), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, _templateString);
            buffer_save(_buffer, $"{_directory}/{GetName()}.yy");
            buffer_delete(_buffer);
        }
    }
}
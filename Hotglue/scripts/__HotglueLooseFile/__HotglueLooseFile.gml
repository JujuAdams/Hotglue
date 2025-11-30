// Feather disable all

/// @param path

function __HotglueLooseFile(_path) constructor
{
    __path = _path;
    
    __recommendedType = "included file";
    
    var _extension = filename_ext(_path);
    if (_extension == ".gml")
    {
        __recommendedType = "script";
    }
    else if ((_extension == ".wav")
         ||  (_extension == ".wave")
         ||  (_extension == ".ogg")
         ||  (_extension == ".mp3"))
    {
        __recommendedType = "sound";
    }
    else if ((_extension == ".gif")
         ||  (_extension == ".png")
         ||  (_extension == ".jpg")
         ||  (_extension == ".jpeg")
         ||  (_extension == ".bmp"))
    {
        __recommendedType = "sprite";
    }
    else if (_extension == ".md")
    {
        __recommendedType = "note";
    }
    
    if (__recommendedType == "included file")
    {
        __name = filename_name(_path);
    }
    else
    {
        __name = filename_change_ext(filename_name(_path), "");
    }
    
    __type = __recommendedType;
    
    
    
    static GetPath = function()
    {
        return __path;
    }
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetRecommendedType = function()
    {
        return __recommendedType;
    }
    
    static __GenerateAsset = function(_project, _subfolder = "")
    {
        if (__type == "included file")
        {
            return new __HotglueIncludedFile({
                name: __name,
                filePath: "datafiles",
            });
        }
        else
        {
            if (_subfolder == "")
            {
                var _parentPath = _project.GetName();
                var _parentName = $"{_project.GetName()}.yyp";
            }
            else
            {
                var _parentPath = $"folders/{_subfolder}/";
                var _parentName = $"{filename_name(_subfolder)}.yy";
            }
            
            var _data = {
                name: __name,
                parent: {
                    path: _parentPath,
                    name: _parentName,
                },
            };
            
            if (__type == "script")
            {
                return new __HotglueResourceSprite(_data);
            }
            else if (__type == "sound")
            {
                return new __HotglueResourceSound(_data);
            }
            else if (__type == "sprite")
            {
                return new __HotglueResourceSprite(_data);
            }
            else if (__type == "note")
            {
                return new __HotglueResourceNote(_data);
            }
            else
            {
                __HotglueError($"Unhandled type \"{_type}\"");
            }
        }
    }
    
    static __CreateFilesInProject = function(_project, _asset)
    {
        if (__type == "included file")
        {
            file_copy(__path, $"{_project.__projectDirectory}datafiles/{__name}");
        }
        else
        {
            
        }
    }
}
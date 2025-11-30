// Feather disable all

/// @param path

function __HotglueLooseFile(_path) constructor
{
    __path  = _path;
    __name  = filename_change_ext(filename_name(_path), "");
    __asset = undefined;
    
    __recommendedType = "included file";
    __recommendedResourceType = undefined;
    
    var _extension = filename_ext(_path);
    if (_extension == ".gml")
    {
        __recommendedType = "resource";
        __recommendedResourceType = "script";
    }
    else if ((_extension == ".wav")
         ||  (_extension == ".wave")
         ||  (_extension == ".ogg")
         ||  (_extension == ".mp3"))
    {
        __recommendedType = "resource";
        __recommendedResourceType = "sound";
    }
    else if ((_extension == ".gif")
         ||  (_extension == ".png")
         ||  (_extension == ".jpg")
         ||  (_extension == ".jpeg")
         ||  (_extension == ".bmp"))
    {
        __recommendedType = "resource";
        __recommendedResourceType = "sprite";
    }
    else if (_extension == ".md")
    {
        __recommendedType = "resource";
        __recommendedResourceType = "note";
    }
    
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
    
    static GetRecommendedResourceType = function()
    {
        return __recommendedResourceType;
    }
    
    static PrepareAsRecommended = function()
    {
        if (__recommendedResourceType == "script")
        {
            PrepareAsScript();
        }
        else if (__recommendedResourceType == "sound")
        {
            PrepareAsSound();
        }
        else if (__recommendedResourceType == "sprite")
        {
            PrepareAsSprite();
        }
        else if (__recommendedResourceType == "note")
        {
            PrepareAsNote();
        }
        else
        {
            PrepareAsIncludedFile();
        }
    }
    
    static PrepareAsScript = function(_name = __name)
    {
        __asset = new __HotglueResourceScript({});
    }
    
    static PrepareAsSound = function(_name = __name)
    {
        __asset = new __HotglueResourceSound({});
    }
    
    static PrepareAsSprite = function(_name = __name)
    {
        __asset = new __HotglueResourceSprite({});
    }
    
    static PrepareAsNote = function(_name = __name)
    {
        __asset = new __HotglueResourceNote({});
    }
    
    static PrepareAsIncludedFile = function(_name = filename_name(__path))
    {
        __asset = new __HotglueIncludedFile({
            name: _name,
            filePath: __path,
        });
    }
}
// Feather disable all

/// @param path

function __HotglueLooseFile(_path) constructor
{
    __path = _path;
    __name = filename_change_ext(filename_name(_path), "");
    
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
}
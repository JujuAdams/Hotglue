// Feather disable all

/// @param url
/// @param variant
/// @param name
/// @param remote

function __ClassSource(_url, _variant, _name, _remote) constructor
{
    __key = $"{_url} :: {_variant}";
    
    __url     = _url;
    __remote  = _remote;
    __name    = _name;
    __variant = _variant;
    
    __cachePath = undefined;
    __cacheDirectory = undefined;
    
    __unpacking = false;
    
    static GetURL = function()
    {
        return __url;
    }
    
    static GetRemote = function()
    {
        return __remote;
    }
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetVariant = function()
    {
        return __variant;
    }
    
    static GetPath = function()
    {
        if (__cachePath == undefined)
        {
            __Unpack();
        }
        
        return __cachePath;
    }
    
    static GetDirectory = function()
    {
        if (__cacheDirectory == undefined)
        {
            __Unpack();
        }
        
        return __cacheDirectory;
    }
    
    static GetUnpacking = function()
    {
        return __unpacking;
    }
    
    static ClearCache = function()
    {
        if (__cacheDirectory == undefined) return;
        
        directory_destroy(__cacheDirectory);
        
        __cachePath = undefined;
        __cacheDirectory = undefined;
    }
    
    static __Unpack = function()
    {
        if (__cachePath != undefined) return;
        if (__unpacking) return;
        
        if (__remote)
        {
            __unpacking = true;
            //TODO - Send HTTP request
        }
        else
        {
            //TODO - Unzip
        }
    }
}
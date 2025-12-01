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
    
    __unpackState = 0; // 0 = waiting, 1 = pending, 2 = unpacked
    __inTempCache = false;
    
    __unpackedPath      = undefined;
    __unpackedDirectory = undefined;
    
    
    
    
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
    
    static GetExists = function()
    {
        if (__cached)
        {
            return (GetPath() != undefined);
        }
        else
        {
            if (GetPath() != undefined) return true;
            return GetUnpacking()? undefined : false;
        }
    }
    
    static GetPath = function(_allowCache = true)
    {
        if (_allowCache) __Unpack();
        return __unpackedPath;
    }
    
    static GetDirectory = function(_allowCache = true)
    {
        if (_allowCache) __Unpack();
        return __unpackedDirectory;
    }
    
    static GetUnpackPending = function()
    {
        return (__unpackState == 1);
    }
    
    static GetUnpacked = function()
    {
        return (__unpackState == 2);
    }
    
    static ClearCache = function()
    {
        if (__unpackState == 0) return;
        
        if (__inTempCache)
        {
            directory_destroy(__cacheDirectory);
        }
        
        __unpackState = 0;
        __inTempCache = false;
        
        __unpackedPath      = undefined;
        __unpackedDirectory = undefined;
    }
    
    static __Unpack = function()
    {
        if (__unpackState != 0) return;
        if (__unpacking) return;
        
        if (__remote)
        {
            __unpackState = 1;
            __inTempCache = true;
            
            http_get_file(__url, "cache");
        }
        else
        {
            __unpackState = 2;
            __inTempCache = false;
            
            var _extension = filename_ext(__url);
            if ((_extension == ".yyp") || (_extension == ".yymps") || (_extension == ".yyz"))
            {
                __unpackedPath      = __url;
                __unpackedDirectory = filename_dir(__url) + "/";
            }
            else
            {
                __unpackedPath      = undefined;
                __unpackedDirectory = undefined;
            }
        }
    }
}
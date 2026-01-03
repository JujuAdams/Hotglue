// Feather disable all

/// @param hash

function __HttpCacheGetElapsedTime(_hash)
{
    static _cacheTimeMap = __HttpCacheSystem().__cacheTimeMap;
    
    var _time = undefined;
    try
    {
        _time = real(_cacheTimeMap[? _hash]);
    }
    catch(_error)
    {
        
    }
    
    return _time ?? 0;
}
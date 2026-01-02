// Feather disable all

/// @param hash

function __HTTPCacheGetElapsedTime(_hash)
{
    static _cacheTimeMap = __HTTPCacheSystem().__cacheTimeMap;
    
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
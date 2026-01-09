// Feather disable all

/// @param hash
/// @param lifetimeMins

function __HttpCacheAdd(_hash, _lifetimeMins)
{
    static _system       = __HttpCacheSystem();
    static _cacheTimeMap = _system.__cacheTimeMap;
    
    var _elapseTime = date_inc_minute(__HTTPGetUTCTime(), _lifetimeMins);
    
    if (HTTP_CACHE_VERBOSE)
    {
        __HttpCacheTrace($"Adding \"{_hash}\" to cache, elapse time = {date_datetime_string(_elapseTime)}");
    }
    
    _cacheTimeMap[? _hash] = string_format(_elapseTime, 0, 10);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        __HttpCacheSaveString(__HttpCacheGetPath("manifest.json"), json_encode(_cacheTimeMap));
    }
}
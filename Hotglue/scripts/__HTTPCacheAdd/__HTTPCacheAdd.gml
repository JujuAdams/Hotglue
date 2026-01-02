// Feather disable all

/// @param hash
/// @param durationMins

function __HTTPCacheAdd(_hash, _durationMins)
{
    static _system       = __HTTPCacheSystem();
    static _cacheTimeMap = _system.__cacheTimeMap;
    
    var _elapseTime = date_inc_minute(__HTTPGetUTCTime(), _durationMins);
    
    if (HTTP_CACHE_VERBOSE)
    {
        __HTTPCacheTrace($"Adding \"{_hash}\" to cache, elapse time = {date_datetime_string(_elapseTime)}");
    }
    
    _cacheTimeMap[? _hash] = string_format(_elapseTime, 0, 10);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        __HTTPCacheSaveString(__HTTPCacheGetPath("manifest.json"), json_encode(_cacheTimeMap));
    }
}
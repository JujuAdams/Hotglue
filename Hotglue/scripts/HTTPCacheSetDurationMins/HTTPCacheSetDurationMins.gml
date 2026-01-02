// Feather disable all

/// Sets the duration for which *future* cached files will be considered valid.
/// 
/// @param minutes

function HTTPCacheSetDurationMins(_minutes)
{
    static _system = __HTTPCacheSystem();
    
    _minutes = max(0, _minutes);
    
    if (_system.__globalDurationMins != _minutes)
    {
        _system.__globalDurationMins = _minutes;
        
        if (HTTP_CACHE_VERBOSE)
        {
            __HTTPCacheTrace($"Set cache duration to {_minutes} minues");
        }
    }
}
// Feather disable all

/// Sets the duration for which *future* cached files will be considered valid.
/// 
/// @param minutes

function HttpCacheSetLifetimeMins(_minutes)
{
    static _system = __HttpCacheSystem();
    
    _minutes = max(0, _minutes);
    
    if (_system.__globalLifetimeMins != _minutes)
    {
        _system.__globalLifetimeMins = _minutes;
        
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace($"Set cache lifetime to {_minutes} minues");
        }
    }
}
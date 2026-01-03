// Feather disable all

/// Returns the duration for which *future* cached files will be considered valid.

function HttpCacheGetDurationMins()
{
    static _system = __HttpCacheSystem();
    
    return _system.__globalDurationMins;
}
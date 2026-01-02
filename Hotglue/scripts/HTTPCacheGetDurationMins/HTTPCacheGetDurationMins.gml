// Feather disable all

/// Returns the duration for which *future* cached files will be considered valid.

function HTTPCacheGetDurationMins()
{
    static _system = __HTTPCacheSystem();
    
    return _system.__globalDurationMins;
}
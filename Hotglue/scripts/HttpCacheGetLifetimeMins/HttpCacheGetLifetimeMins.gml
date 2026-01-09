// Feather disable all

/// Returns the duration for which *future* cached files will be considered valid.

function HttpCacheGetLifetimeMins()
{
    static _system = __HttpCacheSystem();
    
    return _system.__globalLifetimeMins;
}
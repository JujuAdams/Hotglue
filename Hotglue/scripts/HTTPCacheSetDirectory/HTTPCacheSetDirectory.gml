// Feather disable all

/// Sets the absolute path to the cache directory. If the new path is different to the previous
/// path then the cache will be cleared.
/// 
/// N.B. The behaviour of this function is not dependent on whether local disk caching is
///      available.
/// 
/// @param path

function HttpCacheSetDirectory(_path)
{
    static _system = __HttpCacheSystem();
    
    if (_path != _system.__cacheDirectory)
    {
        HttpCacheClear();
        _system.__cacheDirectory = _path;
    }
}
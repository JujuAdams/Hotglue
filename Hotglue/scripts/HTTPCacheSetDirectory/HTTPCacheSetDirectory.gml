// Feather disable all

/// Sets the absolute path to the cache directory.
/// 
/// @param path

function HTTPCacheSetDirectory(_path)
{
    static _system = __HTTPCacheSystem();
    
    _system.__cacheDirectory = _path;
}
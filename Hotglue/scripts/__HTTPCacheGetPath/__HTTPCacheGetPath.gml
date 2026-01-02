// Feather disable all

/// @param localPath

function __HTTPCacheGetPath(_localPath)
{
    static _system = __HTTPCacheSystem();
    return $"{_system.__cacheDirectory}{_localPath}";
}
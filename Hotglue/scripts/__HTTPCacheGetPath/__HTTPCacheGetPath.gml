// Feather disable all

/// @param localPath

function __HttpCacheGetPath(_localPath)
{
    static _system = __HttpCacheSystem();
    return $"{_system.__cacheDirectory}{_localPath}";
}
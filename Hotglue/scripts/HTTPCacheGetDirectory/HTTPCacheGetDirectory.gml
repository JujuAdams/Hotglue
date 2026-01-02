// Feather disable all

/// Returns the absolute path to the cache directory. By default, this is set on boot to
/// `game_save_id + "httpCache/"` (a folder called "httpCache" in the application sandbox save
/// area).
/// 
/// N.B. This function will still return a path even if local disk caching is unavailable. The
///      returned path is not guaranteed to be valid in that situation.

function HTTPCacheGetDirectory()
{
    static _system = __HTTPCacheSystem();
    
    return _system.__cacheDirectory;
}
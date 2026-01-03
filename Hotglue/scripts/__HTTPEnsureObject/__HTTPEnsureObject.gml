// Feather disable all

function __HTTPEnsureObject()
{
    if (not instance_exists(__objHttpCache))
    {
        if (HTTP_CACHE_VERBOSE)
        {
            __HttpCacheTrace("Created HttpCache object instance");
        }
        
        instance_create_depth(0, 0, 0, __objHttpCache);
    }
    
    return __objHttpCache.id;
}
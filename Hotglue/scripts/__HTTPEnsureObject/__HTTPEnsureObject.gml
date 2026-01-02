// Feather disable all

function __HTTPEnsureObject()
{
    if (not instance_exists(__objHTTPCache))
    {
        if (HTTP_CACHE_VERBOSE)
        {
            __HTTPCacheTrace("Created HTTPCache object instance");
        }
        
        instance_create_depth(0, 0, 0, __objHTTPCache);
    }
    
    return __objHTTPCache.id;
}
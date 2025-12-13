// Feather disable all

/// @param url

function __HotglueRepositoryCommon(_url) constructor
{
    static __isRemote = false;
    
    __url = _url
    
    __readme          = undefined;
    __readmeCollected = false;
    __readmeRequest   = undefined;
    
    __releasesArray     = [];
    __releasesCollected = false;
    __releasesRequest   = undefined;
    
    __latestStable  = undefined;
    __latestRelease = undefined;
    
    __finalCallback = undefined;
    
    
    
    static GetURL = function()
    {
        return __url;
    }
    
    static GetName = function()
    {
        return __name;
    }
    
    static SetFinalCallback = function(_callback)
    {
        __finalCallback = _callback;
        
        return self;
    }
    
    static __ExecuteFinalCallback = function()
    {
        if ((__readmeRequest == undefined) && (__releasesRequest == undefined))
        {
            if (is_callable(__finalCallback))
            {
                __finalCallback(self);
            }
        }
    }
}
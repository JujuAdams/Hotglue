// Feather disable all

/// @param channel
/// @param url

function __HotglueRepositoryCommon(_channel, _url) constructor
{
    static __type = HOTGLUE_REPOSITORY_LOCAL;
    static __isRemote = false;
    
    __channel = _channel;
    __url     = _url
    
    __name = "???";
    
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
    
    static GetType = function()
    {
        return __type;
    }
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetReadme = function()
    {
        return __readme;
    }
    
    static GetReleasesCollected = function()
    {
        return __releasesCollected;
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
    
    static Refresh = function()
    {
        __readmeCollected = false;
        __releasesCollected = false;
    }
}
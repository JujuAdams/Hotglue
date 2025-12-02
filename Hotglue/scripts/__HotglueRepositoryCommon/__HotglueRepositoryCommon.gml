// Feather disable all

/// @param url

function __HotglueRepositoryCommon(_url) constructor
{
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
        if ((__hotglueJSONRequest == undefined) && (__releasesRequest == undefined))
        {
            if (is_callable(__finalCallback))
            {
                __finalCallback(self);
            }
        }
    }
}
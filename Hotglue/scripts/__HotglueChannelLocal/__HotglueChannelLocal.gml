// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelLocal(_name, _url, _protected) : __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __isRemote = false;
    
    __repositoryArray = [];
    
    __refreshCallback = undefined;
    
    
    
    static Refresh = function(_callback)
    {
        //Allow redefinition of the callback
        __refreshCallback = _callback;
        
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            if (_repositoryArray[_i].GetFileExists())
            {
                array_delete(_repositoryArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        if (is_callable(_callback))
        {
            call_later(1, time_source_units_frames, function()
            {
                __refreshCallback(self, true);
            });
        }
    }
}
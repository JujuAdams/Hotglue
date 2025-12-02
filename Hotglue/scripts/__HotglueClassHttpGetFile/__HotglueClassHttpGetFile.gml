// Feather disable all

/// @param url
/// @param destination

function __HotglueClassHttpGetFile(_url, _destination) constructor
{
    __url = _url;
    __destination = _destination;
    
    __requestID = http_get_file(__url, __destination);
    __HotglueSystem().__httpRequestMap[? __requestID] = self;
    
    __callback = function(_success, _result) {};
    
    
    
    static GetURL = function()
    {
        return __url;
    }
    
    static Callback = function(_callback)
    {
        __callback = _callback;
        return self;
    }
}
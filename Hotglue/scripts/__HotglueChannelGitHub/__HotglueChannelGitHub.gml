// Feather disable all

/// @param url

function __HotglueChannelGitHub(_name, _url) : __HotglueChannelCommon(_name, _url) constructor
{
    __httpRequest = undefined;
    __httpSuccess = false;
    
    
    
    static GetHTTPSuccess = function()
    {
        return __httpSuccess;
    }
    
    static GetRefreshing = function()
    {
        return (__httpRequest != undefined);
    }
    
    static Refresh = function(_callback)
    {
        //Always redefinition of the callback
        __refreshCallback = _callback;
        
        if (__httpRequest == undefined)
        {
            __HotglueTrace($"Refreshing channel \"{__url}\"");
            __httpRequest = new __HotglueClassHttpRequest(__url);
            
            __httpRequest.Callback(function(_httpRequest, _success, _result)
            {
                __httpRequest = undefined;
                
                if (not _success)
                {
                    __HotglueWarning($"\"{_httpRequest.GetURL()}\" HTTP request failed");
                }
                else
                {
                    try
                    {
                        var _json = json_parse(_result);
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                        __HotglueWarning($"\"{_httpRequest.GetURL()}\" HTTP request was successful but failed to parse JSON");
                        _success = false;
                    }
                    
                    if (_success)
                    {
                        _success = false;
                        
                        var _version = _json[$ "version"];
                        if (is_numeric(_version) && (_version == 0))
                        {
                            var _urlArray = _json[$ "links"];
                            if (not is_array(_urlArray))
                            {
                                __HotglueWarning($"\"{_httpRequest.GetURL()}\" Link array invalid");
                            }
                            else
                            {
                                __HotglueTrace($"Refreshed channel \"{__url}\". Found {array_length(_urlArray)} links");
                                
                                Deserialize(_urlArray);
                                
                                _success = true;
                            }
                        }
                        else
                        {
                            __HotglueWarning($"\"{_httpRequest.GetURL()}\" JSON version \"{_version}\" unsupported");
                        }
                    }
                }
            
                __httpSuccess = _success;
                
                if (is_callable(__refreshCallback))
                {
                    __refreshCallback(self, _success);
                }
            });
            
            __httpRequest.Send();
        }
    }
}
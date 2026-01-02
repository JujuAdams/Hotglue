// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelGitHub(_name, _url, _protected) : __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __type = HOTGLUE_CHANNEL_JSON;
    
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
            
            __httpRequest = __HotglueHTTPRequest(__url, self, function(_success, _result, _responseHeaders, _callbackMetadata)
            {
                with(_callbackMetadata)
                {
                    __httpRequest = undefined;
                    
                    if (not _success)
                    {
                        __HotglueWarning($"\"{__url}\" HTTP request failed");
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
                            __HotglueWarning($"\"{__url}\" HTTP request was successful but failed to parse JSON");
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
                                    __HotglueWarning($"\"{__url}\" Link array invalid");
                                }
                                else
                                {
                                    __HotglueTrace($"Refreshed channel \"{__url}\". Found {array_length(_urlArray)} links");
                                
                                    ClearRepositories();
                                    DeserializeURLArray(_urlArray);
                                    SortArray();
                                    
                                    _success = true;
                                }
                            }
                            else
                            {
                                __HotglueWarning($"\"{__url}\" JSON version \"{_version}\" unsupported");
                            }
                        }
                    }
                    
                    __httpSuccess = _success;
                    
                    if (is_callable(__refreshCallback))
                    {
                        __refreshCallback(self, _success);
                    }
                }
            });
        }
    }
}
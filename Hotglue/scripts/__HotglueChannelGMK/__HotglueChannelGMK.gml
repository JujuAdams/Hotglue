// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelGMK(_name, _url, _protected) : __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __type = HOTGLUE_CHANNEL_GMK;
    
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
                            
                            if (not is_array(_json))
                            {
                                __HotglueWarning($"\"{__url}\" item array invalid");
                            }
                            else
                            {
                                ClearRepositories();
                                
                                __HotglueTrace($"Refreshed channel \"{__url}\". Found {array_length(_json)} items");
                                
                                var _i = 0;
                                repeat(array_length(_json))
                                {
                                    var _link = _json[_i][$ "link"];
                                    if (is_string(_link))
                                    {
                                        if (__HotglueGuessURLIsGitHub(_link) || __HotglueGuessURLIsGist(_link) || __HotglueGuessURLIsItch(_link))
                                        {
                                            AddRepository(_link);
                                        }
                                        else
                                        {
                                            __HotglueWarning($"Item {_i} does not have a GitHub repository or itch.io link ({_link})");
                                        }
                                    }
                                    else
                                    {
                                        __HotglueWarning($"Item {_i} has no .link value");
                                    }
                                    
                                    ++_i;
                                }
                                
                                SortArray();
                                _success = true;
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
// Feather disable all

function __HotglueChannelGitHubAuthUser() : __HotglueChannelCommon("Auth'd GitHub User", "https://api.github.com/user/repos?sort=updated&per_page=100", true) constructor
{
    static __type = HOTGLUE_CHANNEL_GITHUB_AUTH_USER;
    
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
                        ClearRepositories();
                        
                        __HotglueTrace($"Recevied {array_length(_json)} repositories");
                        
                        var _i = 0;
                        repeat(array_length(_json))
                        {
                            var _url = $"https://www.github.com/{_json[_i].full_name}";
                            AddRepository(_url);
                            ++_i;
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
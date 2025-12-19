// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelGitHubOrg(_name, _url, _protected) : __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __type = HOTGLUE_CHANNEL_GITHUB_ORG;
    
    __httpRequest = undefined;
    __httpSuccess = false;
    
    var _orgName = _url;
    
    if (filename_name(_orgName) == "")
    {
        _orgName = filename_dir(_url);
    }
    
    _orgName = filename_name(_orgName);
    
    __endpointURL = $"https://api.github.com/orgs/{_orgName}/repos?per_page=100";
    
    
    
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
            __HotglueTrace($"Refreshing channel \"{__endpointURL}\"");
            
            __httpRequest = new __HotglueClassHttpRequest(__endpointURL);
            
            __httpRequest.Callback(function(_httpRequest, _success, _result, _responseHeaders)
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
                        
                        SortArray();
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
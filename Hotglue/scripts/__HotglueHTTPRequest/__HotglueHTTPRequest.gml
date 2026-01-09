// Feather disable all

/// @param url
/// @param [callbackMetadata=undefined]
/// @param callback
/// @param [forceRedownload=false]

function __HotglueHTTPRequest(_url, _callbackMetadata = undefined, _callback, _forceRedownload = false)
{
    static _system = __HotglueSystem();
    static _headerMap = ds_map_create();
    
    //Detect if we need a GitHub bearer token
    if (__HotglueGuessURLIsGitHub(_url))
    {
        if (_system.__githubUserAccessToken != undefined)
        {
            _headerMap[? "Bearer"       ] = _system.__githubUserAccessToken;
            _headerMap[? "Authorization"] = $"Bearer {_system.__githubUserAccessToken}"
        }
    }
    
    var _id = HttpCacheRequest(_url, "GET", _headerMap, "", _callback, _callbackMetadata, _forceRedownload);
    
    ds_map_clear(_headerMap);
    
    return _id;
}
// Feather disable all

/// @param [callback]
/// @param [forceWeb=false]

function HotglueGitHubWebAuthFlow(_callback, _forceWeb = false)
{
    static _system = __HotglueSystem();
    
    _system.__gitHubAuthCallback = _callback;
    
    __HotglueLoadGitHubAccessToken();
    
    if (_forceWeb || (_system.__githubUserAccessToken == undefined))
    {
        _system.__expectingAuth = true;
        
        __HotglueTrace("Opening web page for authorization");
        url_open($"https://github.com/login/oauth/authorize?client_id={HOTGLUE_GITHUB_CLIENT_ID}&scope={HOTGLUE_GITHUB_AUTH_SCOPE}");
    }
    else
    {
        if (is_callable(_callback))
        {
            call_later(1, time_source_units_frames, function()
            {
                __HotglueSystem().__gitHubAuthCallback(true);
            });
        }
    }
}
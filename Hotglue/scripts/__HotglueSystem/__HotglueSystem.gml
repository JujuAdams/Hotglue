// Feather disable all

function __HotglueSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    if (GM_is_sandboxed)
    {
        __HotglueError("Please disable sandboxing for this platform.");
    }
    
    _system = {};
    with(_system)
    {
        __suppressGitAssert = false;
        __destructiveCopy   = true;
        
        __githubUserAccessToken = undefined;
        
        //Port to connect on as part of the `.requestAuthenticationViaWebPage()` flow. This must match the callback URL entered whe creating your GitHub app.
        //e.g. Setting `GITHUB_GML_LOCALHOST_PORT` to `52499` means that you should use `http://localhost:52499/` for the callback URL.
        __localhostPort = 52499;
        
        __traceHandler   = function(_string) { show_debug_message($"Hotglue: {_string}"); };
        __warningHandler = function(_string) { show_debug_message($"Hotglue: Warning! {_string}"); };
        
        __httpRequestMap = ds_map_create();
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __HotglueEnsureObject();
        },
        [], -1));
        
        __HotglueLoadGitHubAccessToken();
    }
    
    if (GM_build_type == "run")
    {
        global.Hotglue = _system;
    }
    
    return _system;
}
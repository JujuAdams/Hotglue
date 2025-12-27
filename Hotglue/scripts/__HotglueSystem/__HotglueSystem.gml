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
        randomize(); //TODO - Swap over to a PRNG
        
        __traceHandler   = function(_string) { show_debug_message($"Hotglue: {_string}"); };
        __warningHandler = function(_string) { show_debug_message($"Hotglue: Warning! {_string}"); };
        
        __suppressGitAssert = false;
        __destructiveCopy   = true;
        
        __uriTestSuccess = false;
        __uriTestTimeout = undefined;
        
        __cachePath = HOTGLUE_DEFAULT_PATH_CACHE;
        directory_create(__cachePath);
        
        if (os_type == os_windows)
        {
            __projectToolPath = HOTGLUE_DEFAULT_PATH_PROJECTTOOL;
        }
        else if (os_type == os_macosx)
        {
            __projectToolPath = ""; //FIXME - Find the project tool path
        }
        else
        {
            __projectToolPath = "";
        }
        
        __githubUserAccessToken = undefined;
        
        //Port to connect on as part of the `.requestAuthenticationViaWebPage()` flow. This must match the callback URL entered whe creating your GitHub app.
        //e.g. Setting `GITHUB_GML_LOCALHOST_PORT` to `52499` means that you should use `http://localhost:52499/` for the callback URL.
        __localhostPort = 52499;
        
        __udpSocket = network_create_socket_ext(network_socket_udp, 52500);
        LogTrace($"UDP socket = {__udpSocket}");
        
        __httpRequestMap = ds_map_create();
        
        __projectByPathDict = {};
        __projectBySourceURLDict = {};
        
        __channelArray = [];
        array_push(__channelArray, new __HotglueChannelFavorites("* Favourites *", HOTGLUE_FAVORITES_CHANNEL, true));
        array_push(__channelArray, new __HotglueChannelLocal("Local Machine", HOTGLUE_LOCALS_CHANNEL, true));
        
        __repositoryArray = [];
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __HotglueEnsureObject();
        },
        [], -1));
        
        HotglueClearTempCache();
        __HotglueLoadGitHubAccessToken();
    }
    
    if (GM_build_type == "run")
    {
        global.Hotglue = _system;
    }
    
    return _system;
}
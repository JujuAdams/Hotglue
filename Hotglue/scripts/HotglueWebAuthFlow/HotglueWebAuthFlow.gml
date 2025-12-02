// Feather disable all

/// @param [callback]

function HotglueWebAuthFlow(_callback)
{
    static _system = __HotglueSystem();
    
    _system.__gitHubAuthCallback = _callback;
    
    with(__HotglueEnsureObject())
    {
        if (__server == undefined)
        {
            __server = network_create_server_raw(network_socket_tcp, _system.__localhostPort, 1);
            
            if (__server < 0)
            {
                __HotglueWarning("Failed to create server for GitHub auth callback");
                
                //Execute the callback next step
                if (is_callable(_callback))
                {
                    call_later(1, time_source_units_frames, function()
                    {
                        __HotglueSystem().__gitHubAuthCallback(false);
                    });
                }
            }
            else
            {
                __HotglueTrace("Created server for GitHub auth callback");
            }
        }
        
        if (__server >= 0)
        {
            __HotglueTrace("Opening web page for authorization");
            url_open($"https://github.com/login/oauth/authorize?client_id={HOUTGLUE_GITHUB_CLIENT_ID}&scope={HOTGLUE_GITHUB_AUTH_SCOPE}");
        }
    }
}
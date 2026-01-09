// Feather disable all

function HotglueURIHandleString(_inString)
{
    static _system = __HotglueSystem();
    
    var _string = _inString;
    
    if (string_copy(_string, 1, string_length("hotglue://")) != "hotglue://")
    {
        LogWarning($"Invalid URI return \"{_string}\"");
        return;
    }
    
    _string = string_delete(_string, 1, string_length("hotglue://"));
    LogTrace($"Received URI return \"{_string}\"");
    
    //Trim off trailing slashes
    if (string_char_at(_string, string_length(_string)) == "/")
    {
        _string = string_copy(_string, 1, string_length(_string)-1);
    }
    
    if (string_char_at(_string, string_length(_string)) == "\\")
    {
        _string = string_copy(_string, 1, string_length(_string)-1);
    }
    
    if (_string == "test")
    {
        if (_system.__uriTestTimeout != undefined)
        {
            _system.__uriTestSuccess = true;
            _system.__uriTestTimeout = undefined;
            __HotglueTrace("URI test successful");
        }
        else
        {
            __HotglueWarning("Received URI test response but we're not testing URI");
        }
    }
    else if (string_copy(_string, 1, string_length("add=")) == "add=")
    {
        var _path = string_delete(_string, 1, string_length("add="));
        __HotglueTrace($"Received URI path \"{_path}\"");
        
        //TODO - Ask for permission
        
        HotglueGetChannelByURL(HOTGLUE_CUSTOM_CHANNEL).AddRepository(_path);
    }
    else if (string_copy(_string, 1, string_length("auth/?code=")) == "auth/?code=")
    {
        if (not _system.__expectingAuth)
        {
            __HotglueWarning("Received authorization URI but not expecting it");
        }
        else
        {
            _system.__expectingAuth = true;
            
            var _code = string_delete(_string, 1, string_length("auth/?code="));
            var _params = $"client_id={HOTGLUE_GITHUB_CLIENT_ID}&client_secret={HOTGLUE_GITHUB_CLIENT_SECRET}&code={_code}";
            
            var _headerMap = ds_map_create();
            _headerMap[? "Accept"] = "application/json";
            
            HttpCacheRequest($"https://github.com/login/oauth/access_token?{_params}", "POST", _headerMap, "", function(_success, _result, _responseHeader, _callbackMetadata)
            {
                with(_callbackMetadata)
                {
                    static _system = __HotglueSystem();
                    
                    var _accessToken = undefined;
                    var _expires = undefined;
                    
                    if (not _success)
                    {
                        __HotglueWarning("Failed to collect access token from GitHub");
                        _success = false;
                    }
                    else
                    {
                        try
                        {
                            var _struct = __HotglueSplitHTMLResponse(_result);
                            __HotglueTrace($"Received access token:\n{json_stringify(_struct, true)}");
                            
                            var _accessToken = _struct.access_token;
                            
                            if (struct_exists(_struct, "expires_in"))
                            {
                                var _expires = date_inc_second(date_current_datetime(), real(_struct.expires_in));
                            }
                            else
                            {
                                var _expires = date_inc_day(date_current_datetime(), 1);
                            }
                        }
                        catch(_error)
                        {
                            __HotglueTrace(_error);
                            __HotglueWarning("Failed to parse access token response");
                            _success = false;
                        }
                    }
                    
                    if (_success)
                    {
                        __HotglueTrace($"Parsed access token successfully. Expires at {date_datetime_string(_expires)}");
                        _system.__githubUserAccessToken = _accessToken;
                        
                        var _json = {
                            accessToken: _accessToken,
                            expires:     _expires,
                        };
                        
                        var _string = json_stringify(_json, true);
                        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
                        buffer_write(_buffer, buffer_text, _string);
                        buffer_save(_buffer, $"{HOTGLUE_AUTH_CACHE_DIRECTORY}github.json");
                        buffer_delete(_buffer);
                    }
                    else
                    {
                        _system.__githubUserAccessToken = undefined;
                    }
                    
                    if (is_callable(_system.__gitHubAuthCallback))
                    {
                        _system.__gitHubAuthCallback(_success);
                    }
                }
            },
            self, undefined, true);
            ds_map_destroy(_headerMap);
        }
    }
    else
    {
        __HotglueWarning($"Unhandled URI format \"{_inString}\"");
    }
}
// Feather disable all

function __HotglueAsyncNetworkingEvent()
{
    static _system = __HotglueSystem();
    
    if ((__server != undefined) && (async_load[? "port"] == _system.__localhostPort))
    {
        var _type = async_load[? "type"];
        if (_type == network_type_connect)
        {
            if (async_load[? "id"] == __server)
            {
                __socket = async_load[? "socket"];
            }
        }
        else if (_type == network_type_disconnect)
        {
            if ((async_load[? "id"] == __server)
            &&  (async_load[? "socket"] == __socket))
            {
                __socket = undefined;
            }
        }
        else
        {
            if (async_load[? "server"] == __server)
            {
                //Extract the HTTP body
                var _buffer = async_load[? "buffer"];
                var _string = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                //Try to find key information from the HTTP header
                var _codePos = string_pos("GET /?code=", _string);
                var _httpPos = string_pos(" HTTP/1.1", _string);
                
                if ((_codePos > 0) && (_httpPos > 0) && (_httpPos > _codePos))
                {
                    //We found the information we need, fire off a request to GitHub to get our access token
                    var _codeEndPos = _codePos + string_length("GET /?code=");
                    var _code = string_copy(_string, _codeEndPos, _httpPos - _codeEndPos);
                    
                    var _params = $"client_id={HOUTGLUE_GITHUB_CLIENT_ID}&client_secret={HOUTGLUE_GITHUB_CLIENT_SECRET}&code={_code}";
                    
                    var _request = new __HotglueClassHttpRequest($"https://github.com/login/oauth/access_token?{_params}", "POST", false);
                    _request.AddHeader("Accept", "application/json");
                    _request.Callback(function(_request, _success, _result)
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
                                var _accessToken = _struct.access_token;
                                var _expires     = date_inc_second(date_current_datetime(), real(_struct.expires_in));
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
                                accessoken: _accessToken,
                                expires:   _expires,
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
                        
                        //Clean up dangling network connections
                        if (__server != undefined)
                        {
                            network_destroy(__server);
                            __server = undefined;
                        }
                        
                        if (__socket != undefined)
                        {
                            network_destroy(__socket);
                            __socket = undefined;
                        }
                    });
                    _request.Send();
                    
                    var _status  = "200 OK";
                    var _content = "GitHub authentication successful. Please return to the Hotglue application.";
                }
                else
                {
                    var _status  = "403 Forbidden";
                    var _content = "GitHub authentication failed. Please check the Hotglue application log for errors.";
                }
                
                //Send a response back to the browser
                var _buffer = buffer_create(1024, buffer_grow, 1);
                buffer_write(_buffer, buffer_text, $"HTTP/1.1 {_status}\nContent-Length: {string_length(_content)}\nContent-Type: text/html\n\n{_content}");
                network_send_raw(__socket, _buffer, buffer_tell(_buffer));
                buffer_delete(_buffer);
                
                //Disconnect from the browser immediately
                if (__socket != undefined)
                {
                    network_destroy(__socket);
                    __socket = undefined;
                }
            }
        }
    }
}
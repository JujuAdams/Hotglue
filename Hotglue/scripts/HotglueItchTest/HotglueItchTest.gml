// Feather disable all

/// @param callback

function HotglueItchTest(_callback)
{
    HttpCacheGet($"https://itch.io/api/1/{HotglueGetItchAPIKey()}/me", function(_success, _result, _responseHeader, _callbackData, _requestURL)
    {
        var _json = undefined;
        
        if (_success)
        {
            try
            {
                _json = json_parse(_result);
            }
            catch(_error)
            {
                __HotglueWarning(json_stringify(_error, true));
                __HotglueWarning("Failed to parse JSON");
            }
            
            if (is_struct(_json))
            {
                if (struct_exists(_json, "errors"))
                {
                    __HotglueWarning("itch.io returned an error");
                    _success = false;
                }
            }
        }
        
        if (_success)
        {
            __HotglueTrace($"itch.io test successful");
        }
        else
        {
            __HotglueWarning($"itch.io test failed");
        }
        
        if (is_callable(_callbackData))
        {
            _callbackData(_success);
        }
    },
    _callback, true);
}
// Feather disable all

function __HotglueLoadGitHubAccessToken()
{
    static _system = __HotglueSystem();
    
    var _path = $"{HOTGLUE_AUTH_CACHE_DIRECTORY}github.json";
    if (file_exists(_path))
    {
        try
        {
            var _buffer = buffer_load(_path);
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);
            
            var _json = json_parse(_string);
            
            if (is_struct(_json))
            {
                var _currentDatetime = date_current_datetime();
                
                __HotglueTrace($"Current datetime = {date_datetime_string(_currentDatetime)}");
                __HotglueTrace($"Access token expires = {date_datetime_string(_json.expires)}");
                
                var _delta = date_compare_time(_currentDatetime, _json.expires);
                __HotglueTrace($"delta = {string_format(_delta, 0, 10)}");
                
                if (_delta > 0)
                {
                    _system.__githubUserAccessToken = _json.accessToken;
                    __HotglueTrace("Extracted access token from cache");
                }
                else
                {
                    __HotglueTrace($"Access token has expired ({date_datetime_string(_json.expires)})");
                }
            }
        }
        catch(_error)
        {
            __HotglueTrace(_error);
            __HotglueWarning($"Failed to parse \"{_path}\"");
        }
    }
}
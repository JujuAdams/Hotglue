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
                if (date_compare_time(date_current_datetime(), _json.expires) < 0)
                {
                    _system.__githubUserAccessToken = _json.accessoken;
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
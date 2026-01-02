// Feather disable all

/// @param url

function __HotglueRepositoryGist(_url) : __HotglueRepositoryCommon(_url) constructor
{
    static __isRemote = true;
    
    //Trim off the last backslash
    if (string_char_at(_url, string_length(_url)) == "/")
    {
        _url = filename_dir(_url);
    }
    
    __gistID   = filename_name(_url);
    __username = filename_name(filename_dir(_url));
    __name     = $"{__username}/{__gistID}";
    
    __apiURL = $"https://api.github.com/gists/{__gistID}";
    
    //Force a fetch of the gist page so we get an accurate name
    GetReleases();
    
    
    
    static GetLatestStable = function()
    {
        if (not __releasesCollected)
        {
            GetReleases();
        }
        
        return __latestStable;
    }
    
    static GetLatestRelease = function()
    {
        if (not __releasesCollected)
        {
            GetReleases();
        }
        
        return __latestRelease;
    }
    
    static GetReadme = function()
    {
        return __readme;
    }
    
    static GetReleases = function()
    {
        if ((not __releasesCollected) && (__releasesRequest == undefined))
        {
            __HotglueTrace($"Getting gist data from \"{__url}\"");
            
            __releasesRequest = __HotglueHTTPRequest(__apiURL, self, function(_success, _result, _responseHeaders, _callbackMetadata)
            {
                with(_callbackMetadata)
                {
                    __releasesCollected = true;
                    __releasesRequest = undefined;
                    
                    if (not _success)
                    {
                        __HotglueWarning($"\"{__apiURL}\" request failed");
                    }
                    else
                    {
                        try
                        {
                            var _json = json_parse(_result);
                        }
                        catch(_error)
                        {
                            show_debug_message(_error);
                            __HotglueWarning($"\"{__apiURL}\" was successful but failed to parse");
                            _success = false;
                        }
                        
                        if (_success)
                        {
                            if (not is_struct(_json))
                            {
                                __HotglueWarning($"\"{__apiURL}\" was successful but JSON format was unrecognized");
                                _success = false;
                            }
                            else
                            {
                                __HotglueTrace($"\"{__apiURL}\" retrieved, creating a release");
                                
                                var _release = undefined;
                                try
                                {
                                    var _fileNamesArray = struct_get_names(_json.files);
                                    __name   = $"{__username}/{_fileNamesArray[0]}";
                                    __readme = _json.description;
                                    
                                    _release = new __HotglueClassReleaseCommon(__name,
                                                                               _json.updated_at,
                                                                               _json.html_url,
                                                                               _json.files[$ _fileNamesArray[0]].raw_url,
                                                                               _json.description,
                                                                               true);
                                }
                                catch(_error)
                                {
                                    __HotglueWarning(json_stringify(_error, true));
                                    __HotglueWarning($"Failed to create release");
                                }
                                
                                if (_release != undefined)
                                {
                                    __releasesArray[@ 0] = _release;
                                    __latestStable       = _release;
                                    __latestRelease      = _release;
                                }
                            }
                        }
                    }
                    
                    __ExecuteFinalCallback();
                }
            });
        }
        
        return __releasesArray;
    }
}
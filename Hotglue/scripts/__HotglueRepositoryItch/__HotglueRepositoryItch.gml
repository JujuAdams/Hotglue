// Feather disable all

/// @param url

function __HotglueRepositoryItch(_url) : __HotglueRepositoryCommon(_url) constructor
{
    static __isRemote = true;
    
    if (string_char_at(_url, string_length(_url)) != "/")
    {
        _url += "/";
    }
    
    var _posA = string_pos("://", _url) + 3;
    var _posB = string_pos(".itch.io/", _url);
    __username = string_copy(_url, _posA, _posB - _posA);
    __name = $"{__username}/{filename_name(filename_dir(_url))}";
    
    __filename = undefined;
    
    
    
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
        //TODO
        return undefined;
    }
    
    static GetReleases = function()
    {
        if ((not __releasesCollected) && (__releasesRequest == undefined))
        {
            __HotglueTrace($"Getting data.json from \"{__url}\"");
            
            __releasesRequest = __HotglueHTTPRequest($"{__url}/data.json", self, function(_success, _result, _responseHeaders, _callbackMetadata)
            {
                with(_callbackMetadata)
                {
                    __releasesCollected = true;
                    __releasesRequest = undefined;
                    
                    if (not _success)
                    {
                        __HotglueWarning($"\"{__url}\" request failed");
                    }
                    else
                    {
                        var _id = undefined;
                        
                        try
                        {
                            var _json = json_parse(_result);
                            _id = _json.id;
                        }
                        catch(_error)
                        {
                            __HotglueWarning(json_stringify(_error, true));
                        }
                        
                        if (_id == undefined)
                        {
                            __HotglueWarning($"\"{__url}\" was successful but failed to parse");
                        }
                        else
                        {
                            __HotglueHTTPRequest($"https://itch.io/api/1/{HOTGLUE_ITCH_API_KEY}/game/{_id}/uploads", self, function(_success, _result, _responseHeaders, _callbackMetadata)
                            {
                                with(_callbackMetadata)
                                {
                                    try
                                    {
                                        var _json = json_parse(_result);
                                        var _uploadsArray = _json.uploads;
                                    }
                                    catch(_error)
                                    {
                                        __HotglueWarning(json_stringify(_error, true));
                                        __HotglueWarning($"\"{__url}\" was successful but failed to parse");
                                        _success = false;
                                    }
                                    
                                    if (_success)
                                    {
                                        var _releasesArray = __releasesArray;
                                        
                                        array_resize(_releasesArray, 0);
                                        __latestStable = undefined;
                                        
                                        __HotglueTrace($"\"{__url}\" request retrieved {array_length(_uploadsArray)} releases");
                                        
                                        var _i = 0;
                                        repeat(array_length(_uploadsArray))
                                        {
                                            var _itchRelease = _uploadsArray[_i];
                                            
                                            try
                                            {
                                                var _uploadID = _itchRelease.id;
                                                var _downloadURL = $"https://itch.io/api/1/{HOTGLUE_ITCH_API_KEY}/upload/{_uploadID}/download";
                                                
                                                var _description = $"Updated at {_itchRelease.updated_at}\nType = \"{_itchRelease.type}\"\nDemo = {_itchRelease.demo? "true" : "false"}";
                                                
                                                var _release = new __HotglueClassReleaseItch(_itchRelease.filename,
                                                                                             _itchRelease.updated_at,
                                                                                             _downloadURL,
                                                                                             _description,
                                                                                             (not _itchRelease.demo),
                                                                                             filename_ext(_itchRelease.filename));
                                        
                                                array_push(_releasesArray, _release);
                                                //__HotglueTrace($"Found release \"{_itchRelease.filename}\"");
                                            }
                                            catch(_error)
                                            {
                                                __HotglueTrace(_error);
                                                __HotglueWarning($"Failed to parse release index {_i}");
                                            }
                                            
                                            ++_i;
                                        }
                                        
                                        //itch.io uploads aren't necessarily sorted
                                        array_sort(_releasesArray, function(_a, _b)
                                        {
                                            return (_a < _b)? -1 : 1;
                                        });
                                        
                                        //Find the first non-demo upload
                                        var _i = 0;
                                        repeat(array_length(_releasesArray))
                                        {
                                            var _release = _releasesArray[_i];
                                            if (_release.__stable)
                                            {
                                                __latestStable = _release;
                                                break;
                                            }
                                            
                                            ++_i;
                                        }
                                        
                                        __latestRelease = array_first(_releasesArray);
                                        
                                        if (is_struct(__latestStable))
                                        {
                                            __HotglueTrace($"Latest stable is \"{__latestStable.GetWebURL()}\"");
                                        }
                                        else
                                        {
                                            __HotglueTrace($"No latest stable found for \"{__url}\"");
                                        }
                                        
                                        if (is_struct(__latestRelease))
                                        {
                                            __HotglueTrace($"Latest release is \"{__latestRelease.GetWebURL()}\"");
                                        }
                                        else
                                        {
                                            __HotglueWarning($"No latest release found for \"{__url}\"");
                                        }
                                    }
                                }
                            });
                        }
                    }
                }
            });
        }
        
        return __releasesArray;
    }
}
// Feather disable all

/// @param url

function __HotglueRepositoryVerdaccio(_url) : __HotglueRepositoryCommon(_url) constructor
{
    static __isRemote = true;
    
    if (string_char_at(_url, string_length(_url)) == "/")
    {
        __url = _url;
        _url = filename_dir(_url);
    }
    else
    {
        __url = _url + "/";
    }
    
    __username = filename_name(filename_dir(_url));
    __name = __username + "/" + filename_name(_url);
    
    __request = undefined;
    
    
    
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
        if ((not __readmeCollected) && (__request == undefined))
        {
            __HotglueTrace($"Getting description/releases from \"{__url}\"");
            __request = __StartRequest();
        }
        
        return __readme;
    }
    
    static GetReleases = function()
    {
        if ((not __releasesCollected) && (__request == undefined))
        {
            __HotglueTrace($"Getting description/releases from \"{__url}\"");
            __request = __StartRequest();
        }
        
        return __releasesArray;
    }
    
    static __StartRequest = function()
    {
        return __HotglueHTTPRequest(__url, self, function(_success, _result, _responseHeaders, _callbackData)
        {
            with(_callbackData)
            {
                __readmeCollected = true;
                __releasesCollected = true;
                __request = undefined;
                
                if (not _success)
                {
                    __HotglueWarning($"\"{__url}\" request failed");
                }
                else
                {
                    var _json = undefined;
                    
                    try
                    {
                        _json = json_parse(_result);
                    }
                    catch(_error)
                    {
                        __HotglueWarning(json_stringify(_error, true));
                    }
                    
                    if (_json == undefined)
                    {
                        __HotglueWarning($"\"{__url}\" was successful but failed to parse");
                    }
                    else
                    {
                        var _latestReleaseName = _json[$ "dist-tags"].latest;
                        
                        var _releasesArray = __releasesArray;
                        array_resize(_releasesArray, 0);
                        __latestRelease = undefined;
                        
                        var _timeDict = _json.time;
                        var _versionsDict = _json.versions;
                        var _versionsNameArray = struct_get_names(_versionsDict);
                        array_sort(_versionsNameArray, false);
                        
                        __HotglueTrace($"\"{__url}\" request retrieved {array_length(_versionsNameArray)} releases");
                        
                        var _i = 0;
                        repeat(array_length(_versionsNameArray))
                        {
                            var _versionName = _versionsNameArray[_i];
                            var _versionData = _versionsDict[$ _versionName];
                            
                            var _release = new __HotglueClassReleaseCommon(_versionName,
                                                                           _timeDict[$ _versionName],
                                                                           __url,
                                                                           _versionData.dist.tarball,
                                                                           _versionData.description,
                                                                           true);
                            array_push(_releasesArray, _release);
                            
                            if (_versionName == _latestReleaseName)
                            {
                                __latestRelease = _release;
                            }
                            
                            ++_i;
                        }
                        
                        __latestStable = __latestRelease;
                        
                        //Use the description from the latest version
                        __readme = (__latestRelease == undefined)? undefined : __latestRelease.__description;
                    }
                }
                
                __ExecuteFinalCallback();
            }
        });
    }
}
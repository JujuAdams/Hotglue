// Feather disable all

/// @param url

function __HotglueRepositoryItch(_url) : __HotglueRepositoryCommon(_url) constructor
{
    static __isRemote = true;
    
    if (string_char_at(_url, string_length(_url)) != "/")
    {
        _url += "/";
    }
    
    __name = _url;
    
    
    
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
        return __releasesArray;
        
        if ((not __releasesCollected) && (__releasesRequest == undefined))
        {
            __HotglueTrace($"Getting releases from \"{__url}\"");
            __releasesRequest = new __HotglueClassHttpRequest($"{__apiURL}releases?per_page={HOTGLUE_MAX_GITHUB_RELEASES}");
            
            __releasesRequest.Callback(function(_httpRequest, _success, _result, _responseHeaders)
            {
                __releasesCollected = true;
                __releasesRequest = undefined;
                
                if (not _success)
                {
                    __HotglueWarning($"\"{_httpRequest.GetURL()}\" request failed");
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
                        __HotglueWarning($"\"{_httpRequest.GetURL()}\" was successful but failed to parse");
                        _success = false;
                    }
                
                    if (_success)
                    {
                        if (not is_array(_json))
                        {
                            __HotglueWarning($"\"{_httpRequest.GetURL()}\" was successful but JSON format was unrecognized");
                            _success = false;
                        }
                        else
                        {
                            var _releasesArray = __releasesArray;
                            
                            array_resize(_releasesArray, 0);
                            __latestStable = undefined;
                            
                            __HotglueTrace($"\"{_httpRequest.GetURL()}\" retrieved {array_length(_json)} releases (maximum is {HOTGLUE_MAX_GITHUB_RELEASES})");
                            
                            var _i = 0;
                            repeat(array_length(_json))
                            {
                                var _githubRelease = _json[_i];
                                
                                try
                                {
                                    var _release = new __HotglueClassReleaseGitHub(_githubRelease.name,
                                                                                   _githubRelease.published_at,
                                                                                   _githubRelease.html_url,
                                                                                   _githubRelease.zipball_url,
                                                                                   _githubRelease.body,
                                                                                   (not _githubRelease.prerelease),
                                                                                   _githubRelease.assets_url);
                                    
                                    array_push(_releasesArray, _release);
                                    //__HotglueTrace($"Found release \"{_githubRelease.name}\"");
                                    
                                    if ((__latestStable == undefined) && (not _githubRelease.prerelease))
                                    {
                                        __latestStable = _release;
                                    }
                                }
                                catch(_error)
                                {
                                    show_debug_message(_error);
                                    __HotglueWarning($"Failed to parse release index {_i}");
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
                                __HotglueTrace($"No latest stable found for \"{_httpRequest.GetURL()}\"");
                            }
                            
                            if (is_struct(__latestRelease))
                            {
                                __HotglueTrace($"Latest release is \"{__latestRelease.GetWebURL()}\"");
                            }
                            else
                            {
                                __HotglueWarning($"No latest release found for \"{_httpRequest.GetURL()}\"");
                            }
                        }
                    }
                }
                
                __ExecuteFinalCallback();
            });
            
            __releasesRequest.Send();
        }
        
        return __releasesArray;
    }
}
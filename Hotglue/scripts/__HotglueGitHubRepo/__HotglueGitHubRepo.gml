// Feather disable all

/// @param url

function __HotglueGitHubRepo(_url) constructor
{
    if (string_char_at(_url, string_length(_url)) != "/")
    {
        _url += "/";
    }
    
    __webURL = _url;
    __apiURL = "https://api.github.com/repos/" + string_delete(_url, 1, string_pos(".com/", _url)-1 + 5);
    
    __hotglueJSON          = undefined;
    __hotglueJSONCollected = false;
    __hotglueJSONRequest   = undefined;
    
    __releasesArray     = [];
    __releasesCollected = false;
    __releasesRequest   = undefined;
    
    __latestStable  = undefined;
    __latestRelease = undefined;
    
    __finalCallback = undefined;
    
    static SetFinalCallback = function(_callback)
    {
        __finalCallback = _callback;
        
        return self;
    }
    
    static __ExecuteFinalCallback = function()
    {
        if ((__hotglueJSONRequest == undefined) && (__releasesRequest == undefined))
        {
            if (is_callable(__finalCallback))
            {
                __finalCallback(self);
            }
        }
    }
    
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
    
    static GetHotglueJSON = function()
    {
        if ((not __hotglueJSONCollected) && (__hotglueJSONRequest == undefined))
        {
            __HotglueTrace($"Getting hotglue.json from root of \"{__webURL}\"");
            __hotglueJSONRequest = new __HotglueClassHttpRequest(__apiURL + "contents/hotglue.json");
            
            __hotglueJSONRequest.Callback(function(_httpRequest, _success, _result)
            {
                __hotglueJSONCollected = true;
                __hotglueJSONRequest = undefined;
                
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
                        _success = false;
                        
                        var _version = _json[$ "version"];
                        if (is_numeric(_version) && (_version == 0))
                        {
                            __hotglueJSON = _json;
                            _success = true;
                            
                            __HotglueTrace($"\"{_httpRequest.GetURL()}\" found hotglue.json");
                        }
                        else
                        {
                            __HotglueWarning($"\"{_httpRequest.GetURL()}\" version \"{_version}\" unsupported");
                        }
                    }
                }
                
                __ExecuteFinalCallback();
            });
            
            __hotglueJSONRequest.Send();
        }
        
        return __hotglueJSON;
    }
    
    static GetReleases = function()
    {
        if ((not __releasesCollected) && (__releasesRequest == undefined))
        {
            __HotglueTrace($"Getting releases from \"{__webURL}\"");
            __releasesRequest = new __HotglueClassHttpRequest($"{__apiURL}releases?per_page={HOTGLUE_MAX_GITHUB_RELEASES}");
            
            __releasesRequest.Callback(function(_httpRequest, _success, _result)
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
                                                                                   _githubRelease.assets_url)
                                    
                                    array_push(_releasesArray, _release);
                                    __HotglueTrace($"Found release \"{_githubRelease.name}\"");
                                    
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
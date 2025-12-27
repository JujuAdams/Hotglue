// Feather disable all

/// @param name
/// @param datetimeString
/// @param webURL
/// @param downloadURL
/// @param description
/// @param stable
/// @param assetsEndpoint

function __HotglueClassReleaseGitHub(_name, _datetimeString, _webURL, _downloadURL, _description, _stable, _assetsEndpoint) : __HotglueClassReleaseCommon(_name, _datetimeString, _webURL, _downloadURL, _description, _stable) constructor
{
    __assetsEndpoint = _assetsEndpoint;
    
    __assetsCollected = false;
    __assetsRequest   = undefined;
    
    
    
    static Download = function(_callback)
    {
        if (__assetsCollected)
        {
            __DownloadInternal(__primaryAssetURL, _callback);
        }
        else
        {
            __downloadCallback = _callback;
            
            __HotglueTrace($"Getting assets \"{__assetsEndpoint}\" to check for a .yymps or .yyz file");
            
            __assetsRequest = new __HotglueClassHttpRequest(__assetsEndpoint);
            __assetsRequest.Callback(function(_httpRequest, _success, _result, _responseHeaders)
            {
                __assetsCollected = true;
                __assetsRequest = undefined;
                
                if (not _success)
                {
                    __HotglueWarning($"\"{__assetsEndpoint}\" request failed");
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
                        __HotglueWarning($"\"{__assetsEndpoint}\" was successful but failed to parse");
                        _success = false;
                    }
                    
                    if (_success)
                    {
                        if (not is_array(_json))
                        {
                            __HotglueWarning($"\"{__assetsEndpoint}\" was successful but JSON format was unrecognized");
                            _success = false;
                        }
                        else
                        {
                            var _found = false;
                            
                            var _i = 0;
                            repeat(array_length(_json))
                            {
                                var _assetData = _json[_i];
                                
                                var _assetName = _assetData.name;
                                if (filename_ext(_assetName) == ".yymps")
                                {
                                    if (_found)
                                    {
                                        __HotglueWarning($"Found multiple .yymps files, choosing the first one we found (conflict=\"{_assetData.browser_download_url}\")");
                                    }
                                    else
                                    {
                                        __primaryAssetURL = _assetData.browser_download_url;
                                        __HotglueTrace($"Found \"{__primaryAssetURL}\"");
                                        _found = true;
                                    }
                                }
                                
                                ++_i;
                            }
                            
                            if (not _found)
                            {
                                var _i = 0;
                                repeat(array_length(_json))
                                {
                                    var _assetData = _json[_i];
                                    
                                    var _assetName = _assetData.name;
                                    if (filename_ext(_assetName) == ".yyz")
                                    {
                                        if (_found)
                                        {
                                            __HotglueWarning($"Found multiple .yyz files, choosing the first one we found (conflict=\"{_assetData.browser_download_url}\")");
                                        }
                                        else
                                        {
                                            __primaryAssetURL = _assetData.browser_download_url;
                                            __HotglueTrace($"Found \"{__primaryAssetURL}\"");
                                            _found = true;
                                        }
                                    }
                                    
                                    ++_i;
                                }
                            }
                            
                            if (not _found)
                            {
                                __HotglueWarning($"Did not find a .yymps or .yyz in releases for \"{__assetsEndpoint}\". Falling back on .zip repository download");
                            }
                            
                            __DownloadInternal(__primaryAssetURL, __downloadCallback);
                        }
                    }
                }
            });
            
            __assetsRequest.Send();
        }
    }
}
// Feather disable all

/// @param name
/// @param datetimeString
/// @param downloadURL
/// @param description
/// @param stable
/// @param fileExtension

function __HotglueClassReleaseItch(_name, _datetimeString, _downloadURL, _description, _stable, _fileExtension) : __HotglueClassReleaseCommon(_name, _datetimeString, _downloadURL, _downloadURL, _description, _stable) constructor
{
    __fileExtension = _fileExtension;
    
    __assetsCollected = false;
    __assetsRequest   = undefined;
    
    
    
    static Download = function(_callback)
    {
        if (__assetsCollected)
        {
            __DownloadInternal(__primaryAssetURL, _callback, __fileExtension);
        }
        else 
        {
            __downloadCallback = _callback;
            
            if (__assetsRequest == undefined)
            {
                __HotglueTrace($"Getting assets \"{__downloadURL}\" to check for a .yymps or .yyz file");
                
                __assetsRequest = __HotglueHTTPRequest(__downloadURL, self, function(_success, _result, _responseHeaders, _callbackMetadata)
                {
                    with(_callbackMetadata)
                    {
                        __assetsCollected = false;
                        __assetsRequest   = undefined;
                        
                        if (not _success)
                        {
                            __HotglueWarning($"\"{__downloadURL}\" releases request failed");
                        }
                        else
                        {
                            try
                            {
                                var _json = json_parse(_result);
                                var _primaryAssetURL = _json.url;
                            }
                            catch(_error)
                            {
                                __HotglueTrace(_error);
                                __HotglueWarning($"\"{__downloadURL}\" request was successful but failed to parse");
                                _success = false;
                            }
                            
                            if (_success)
                            {
                                __primaryAssetURL = _primaryAssetURL;
                                __DownloadInternal(__primaryAssetURL, __downloadCallback, __fileExtension);
                            }
                        }
                    }
                },
                true);
            }
        }
    }
}
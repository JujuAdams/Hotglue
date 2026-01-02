// Feather disable all

/// @param name
/// @param datetimeString
/// @param webURL
/// @param downloadURL
/// @param description
/// @param stable

function __HotglueClassReleaseCommon(_name, _datetimeString, _webURL, _downloadURL, _description, _stable) constructor
{
    __name           = (_name == "")? "<untitled>" : _name;
    __datetimeString = _datetimeString;
    __webURL         = _webURL;
    __downloadURL    = _downloadURL;
    __description    = _description;
    __stable         = _stable;
    
    __primaryAssetURL = _downloadURL;
    
    __downloadPath = $"{HOTGLUE_RELEASE_CACHE_DIRECTORY}{__HotglueGenerateCacheFilename(__datetimeString, __webURL)}.bin";
    __downloadRequest = undefined;
    
    __downloadCallback = undefined;
    __loadCallback = undefined;
    
    
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetDatetimeString = function()
    {
        return __datetimeString;
    }
    
    static GetWebURL = function()
    {
        return __webURL;
    }
    
    static GetDownloadURL = function()
    {
        return __downloadURL;
    }
    
    static GetPrimaryAssetURL = function()
    {
        return __primaryAssetURL;
    }
    
    static GetDownloadPath = function()
    {
        return __downloadPath;
    }
    
    static GetDescription = function()
    {
        return __description;
    }
    
    static GetStable = function()
    {
        return __stable;
    }
    
    static GetDownloaded = function()
    {
        return file_exists(__downloadPath);
    }
    
    static LoadContent = function(_callback)
    {
        __loadCallback = _callback;
        
        Download(function(_release, _success, _result)
        {
            var _struct = undefined;
            
            if (not _success)
            {
                __HotglueWarning($"Release \"{__webURL}\" failed to download");
            }
            else
            {
                var _extension = filename_ext(_result);
                if ((_extension == ".yyp") || (_extension == ".yymps") || (_extension = ".yyz"))
                {
                    _struct = HotglueProjectRemoteEnsure(__webURL, _result);
                    if (_struct == undefined)
                    {
                        __HotglueWarning($"Release \"{__webURL}\" downloaded a file with an invalid extension \"{_result}\"");
                        _success = false;
                    }
                }
                else if ((_extension == ".txt") || (_extension == ".gml") || (_extension = ".md"))
                {
                    _struct = HotglueLoadLooseFile(_result);
                    _struct.SetType("script");
                    _struct.SetName(HotglueSanitizeResourceName(__name));
                }
            }
            
            if (is_callable(__loadCallback))
            {
                __loadCallback(_struct, _success);
            }
        });
    }
    
    static Download = function(_callback)
    {
        __DownloadInternal(__downloadURL, _callback);
    }
    
    static __DownloadInternal = function(_url, _callback, _downloadPath = undefined)
    {
        __downloadCallback = _callback;
        
        __downloadPath = (_downloadPath != undefined)? _downloadPath : filename_change_ext(__downloadPath, filename_ext(_url));
        
        if (file_exists(__downloadPath))
        {
            __HotglueTrace($"\"{_url}\" has been cached, returning local path");
            
            if (is_callable(_callback))
            {
                call_later(1, time_source_units_frames, method({
                    __release: other,
                    __callback: _callback,
                    __result: __downloadPath,
                },
                function()
                {
                    __callback(__release, true, __result);
                }));
            }
        }
        else
        {
            __HotglueTrace($"Downloading \"{_url}\" for release \"{__webURL}\"");
            
            __downloadRequest = new __HotglueClassHttpGetFile(_url, __downloadPath);
            __downloadRequest.Callback(function(_httpRequest, _success, _result, _responseHeaders)
            {
                if (is_callable(__downloadCallback))
                {
                    __downloadCallback(self, _success, _result);
                }
            });
        }
    }
}
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
    
    static LoadProject = function(_callback)
    {
        __loadCallback = _callback;
        
        Download(function(_release, _success, _result)
        {
            var _project = undefined;
            
            if (not _success)
            {
                __HotglueWarning($"Release \"{__webURL}\" failed to download");
            }
            else
            {
                var _project = HotglueProjectRemoteEnsure(__webURL, _result);
                if (_project == undefined)
                {
                    __HotglueWarning($"Release \"{__webURL}\" downloaded a file with an invalid extension \"{_result}\"");
                    _success = false;
                }
            }
            
            if (is_callable(__loadCallback))
            {
                __loadCallback(_project, _success);
            }
        });
    }
    
    static Download = function(_callback)
    {
        __DownloadInternal(__downloadURL, _callback);
    }
    
    static __DownloadInternal = function(_url, _callback)
    {
        __downloadCallback = _callback;
        
        __downloadPath = filename_change_ext(__downloadPath, filename_ext(_url));
        
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
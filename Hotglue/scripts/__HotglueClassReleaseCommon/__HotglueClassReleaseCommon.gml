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
    
    static GetDescription = function()
    {
        return __description;
    }
    
    static GetStable = function()
    {
        return __stable;
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
        __DownloadInternal(__downloadURL, _callback, filename_ext(__downloadURL));
    }
    
    static __DownloadInternal = function(_url, _callback, _fileExtension)
    {
        __downloadCallback = _callback;
        
        HTTPCacheGetFile(_url, undefined, function(_success, _destinationPath, _callbackMetadata)
        {
            with(_callbackMetadata)
            {
                if (is_callable(__downloadCallback))
                {
                    __downloadCallback(self, _success, _destinationPath);
                }
            }
        },
        self, _fileExtension);
    }
}
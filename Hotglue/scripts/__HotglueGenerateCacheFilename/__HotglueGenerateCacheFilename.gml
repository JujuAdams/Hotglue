// Feather disable all

/// @param datetimeString
/// @param webURL

function __HotglueGenerateCacheFilename(_datetimeString, _webURL)
{
    static _funcSanitize = function(_string)
    {
        _string = string_replace_all(_string, "\\", "_");
        _string = string_replace_all(_string,  "/", "_");
        _string = string_replace_all(_string,  " ", "_");
        return _string;
    }
    
    return __HotglueSanitizeFilePath($"{_funcSanitize(_datetimeString)}_{_funcSanitize(_webURL)}");
}
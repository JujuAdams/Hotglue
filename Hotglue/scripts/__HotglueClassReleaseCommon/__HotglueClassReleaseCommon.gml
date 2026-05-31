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
        
        Download(function(_release, _success, _filename)
        {
            var _struct = undefined;
            
            if (not _success)
            {
                __HotglueWarning($"Release \"{__webURL}\" failed to download");
            }
            else
            {
                var _extension = filename_ext(_filename);
                if ((_extension == ".yyp") || (_extension == ".yymps") || (_extension = ".yyz"))
                {
                    _struct = HotglueProjectRemoteEnsure(__webURL, _filename);
                }
                else
                {
                    //TODO - Refactor as async
                    _struct = __OpenContentRecurse(_filename);
                }
                
                if (_struct == undefined)
                {
                    __HotglueWarning($"Release \"{__webURL}\" downloaded file \"{_filename}\" which could not be opened");
                    _success = false;
                }
                else
                {
                    if (is_instanceof(_struct, __HotglueLooseFile))
                    {
                        _struct.SetName(HotglueSanitizeResourceName(__name));
                    }
                }
            }
            
            if (is_callable(__loadCallback))
            {
                __loadCallback(_struct, _success);
            }
        });
    }
    
    static __OpenContentRecurse = function(_path)
    {
        //TODO - Refactor as async
        var _struct = undefined;
        
        var _extension = filename_ext(_path);
        if ((_extension == ".yyp") || (_extension == ".yymps") || (_extension = ".yyz"))
        {
            _struct = HotglueProjectLocalEnsure(_path);
        }
        else if ((_extension == ".txt") || (_extension == ".gml") || (_extension = ".md"))
        {
            _struct = HotglueLoadLooseFile(_path);
            _struct.SetType("script");
        }
        else if (_extension == ".zip")
        {
            __HotglueTrace($"Decompressing \"{_path}\" as zip archive");
            
            var _buffer = buffer_load(_path);
            var _archiveStruct = new HotglueClassZip(_buffer);
            
            var _foundLocalPath = undefined;
            var _foundSize = 0;
            
            var _entryArray = _archiveStruct.__entries;
            __HotglueTrace($"Found {array_length(_entryArray)} entries in zip");
            
            var _i = 0;
            repeat(array_length(_entryArray))
            {
                var _entryStruct = _entryArray[_i];
                var _fileExtension = filename_ext(_entryStruct.__filename);
                
                if ((_fileExtension == ".yyp") || (_fileExtension == ".yymps") || (_fileExtension == ".yyz"))
                {
                    if (_entryStruct.__size > _foundSize)
                    {
                        _foundLocalPath = _entryStruct.__filename;
                        _foundSize = _entryStruct.__size;
                    }
                }
                
                ++_i;
            }
            
            if (_foundLocalPath == undefined)
            {
                __HotglueWarning($"Failed to unarchive \"{_path}\"");
            }
            else
            {
                var _decompressionDirectory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_path)}/";
                
                __HotglueTrace($"Found archive file of interest \"{_foundLocalPath}\" (of {array_length(_entryArray)} files)");
                __HotglueTrace($"Decompressing whole archive to directory \"{_decompressionDirectory}\"");
                
                _archiveStruct.Decompress(_decompressionDirectory);
                _struct = __OpenContentRecurse($"{_decompressionDirectory}{_foundLocalPath}");
            }
            
            _archiveStruct.Destroy();
        }
        else if (_extension == ".tar")
        {
            __HotglueTrace($"Decompressing \"{_path}\" as a tarball archive");
            
            var _buffer = buffer_load(_path);
            var _archiveStruct = new HotglueClassTarball(_buffer);
            
            var _foundLocalPath = undefined;
            var _foundSize = 0;
            
            var _entryArray = _archiveStruct.__entries;
            __HotglueTrace($"Found {array_length(_entryArray)} entries in tarball");
            
            var _i = 0;
            repeat(array_length(_entryArray))
            {
                var _entryStruct = _entryArray[_i];
                var _fileExtension = filename_ext(_entryStruct.__filename);
                
                if ((_fileExtension == ".yyp") || (_fileExtension == ".yymps") || (_fileExtension == ".yyz"))
                {
                    if (_entryStruct.__size > _foundSize)
                    {
                        _foundLocalPath = _entryStruct.__filename;
                        _foundSize = _entryStruct.__size;
                    }
                }
                
                ++_i;
            }
            
            if (_foundLocalPath == undefined)
            {
                __HotglueWarning($"Failed to unarchive \"{_path}\"");
            }
            else
            {
                var _decompressionDirectory = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{md5_string_unicode(_path)}/";
                
                __HotglueTrace($"Found archive file of interest \"{_foundLocalPath}\" (of {array_length(_entryArray)} files)");
                __HotglueTrace($"Decompressing whole archive to directory \"{_decompressionDirectory}\"");
                
                _archiveStruct.Decompress(_decompressionDirectory);
                _struct = __OpenContentRecurse($"{_decompressionDirectory}{_foundLocalPath}");
            }
            
            _archiveStruct.Destroy();
        }
        else if (_extension == ".tgz") || ((_extension == ".gz") && (filename_ext(filename_change_ext(_path, "")) == ".tar"))
        {
            var _intermediatePath = $"{md5_string_unicode(_path)}.tar";
            __HotglueTrace($"Decompressing \"{_path}\" as a gzipped tarball (intermediate file \"{_intermediatePath}\")");
            
            var _buffer = buffer_load(_path);
            var _archiveStruct = new HotglueClassGzip(_buffer);
            var _extractedFilename = _archiveStruct.Decompress(HOTGLUE_UNZIP_CACHE_DIRECTORY, _intermediatePath);
            _archiveStruct.Destroy();
            
            if (_extractedFilename == undefined)
            {
                __HotglueWarning($"Failed to unarchive \"{_path}\"");
            }
            else
            {
                _struct = __OpenContentRecurse(_extractedFilename);
            }
        }
        else if (_extension == ".gz")
        {
            __HotglueTrace($"Decompressing \"{_path}\" as gzipped archive");
            
            var _buffer = buffer_load(_path);
            var _archiveStruct = new HotglueClassGzip(_buffer);
            var _extractedFilename = _archiveStruct.Decompress(HOTGLUE_UNZIP_CACHE_DIRECTORY, undefined);
            _archiveStruct.Destroy();
            
            if (_extractedFilename == undefined)
            {
                __HotglueWarning($"Failed to unarchive \"{_path}\"");
            }
            else
            {
                _struct = __OpenContentRecurse(_extractedFilename);
            }
        }
        else
        {
            __HotglueWarning($"Release \"{__webURL}\" downloaded file \"{_path}\" with an invalid extension");
        }
        
        return _struct;
    }
    
    static Download = function(_callback)
    {
        __DownloadInternal(__downloadURL, _callback, filename_ext(__downloadURL));
    }
    
    static __DownloadInternal = function(_url, _callback, _fileExtension)
    {
        __downloadCallback = _callback;
        
        //FIXME - This all seems wonky. What is meant to happen here?
        
        var _destinationPath = filename_name(_url);
        
        if (_fileExtension != undefined)
        {
            _destinationPath = filename_change_ext(_destinationPath, _fileExtension)
        }
        
        HttpCacheGetFile(_url, _destinationPath, function(_success, _destinationPath, _callbackMetadata)
        {
            with(_callbackMetadata)
            {
                if (is_callable(__downloadCallback))
                {
                    __downloadCallback(self, _success, _destinationPath);
                }
            }
        },
        self, undefined, undefined, __downloadURL);
    }
}
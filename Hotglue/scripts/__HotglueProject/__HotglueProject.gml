// Feather disable all

/// @param projectPath
/// @param readOnly
/// @param sourceURL
/// @param inCache

function __HotglueProject(_projectPath, _readOnly, _sourceURL, _inCache) constructor
{
    static _projectByPathDict = __HotglueSystem().__projectByPathDict;
    static _projectBySourceURLDict = __HotglueSystem().__projectBySourceURLDict;
    
    __HotglueTrace($"Creating project representation \"{_projectPath}\"");
    
    if (not file_exists(_projectPath))
    {
        __HotglueError($"\"{_projectPath}\" doesn't exist");
    }
    
    __projectPath = _projectPath;
    __readOnly    = _readOnly;
    __sourceURL   = _sourceURL;
    __inCache     = _inCache;
    
    __projectDirectory = filename_dir(__projectPath) + "/";
    __converted = false;
    
    __yympsMetadata   = undefined;
    __hotglueMetadata = undefined;
    
    __structure = new __HotglueProjectStructure(self);
    __structureDirty = true;
    __loadedSuccessfully = false;
    
    __yypVersion = undefined;
    __yypOriginalVersion = undefined;
    
    Refresh();
    
    
    
    static Refresh = function()
    {
        __quickAssetArray = [];
        __quickAssetDict  = {};
        
        __yypVersion = undefined;
        __loadedSuccessfully = false;
        
        ///////
        // Load project .yyp
        ///////
        
        var _buffer = buffer_load(__projectPath);
        __yypString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        __yypJson = json_parse(__yypString);
        
        var _yypMetadata = __yypJson[$ "MetaData"];
        if (_yypMetadata == undefined)
        {
            __HotglueWarning($"Could not find \"MetaData\" field in \"{__projectPath}\"");
            return;
        }
        else
        {
            __yypVersion = _yypMetadata[$ "IDEVersion"];
            __yypOriginalVersion = __yypVersion;
            
            if (__yypVersion == undefined)
            {
                __HotglueWarning($"Could not find \"MetaData.IDEVersion\" field in \"{__projectPath}\"");
                return;
            }
            else
            {
                if (not GetYYPVersionSupported())
                {
                    __HotglueWarning($"\"MetaData.IDEVersion\" value invalid ({__yypVersion}) for \"{__projectPath}\"");
                    __HotglueTrace($"Running ProjectTool to convert to latest version");
                    
                    var _newProjectPath = $"{HOTGLUE_UNZIP_CACHE_DIRECTORY}{__HotglueGenerateUUID(false)}/{__yypJson.name}.yyp";
                    var _result = HotglueProjectToolConvert(__projectPath, _newProjectPath);
                    
                    if (not _result)
                    {
                        __HotglueWarning($"Conversion of \"{__projectPath}\" failed");
                        return;
                    }
                    else
                    {
                        __HotglueTrace("Conversion was successful");
                        
                        if (__inCache)
                        {
                            __HotglueTrace($"Cleaning up old cache at \"{__projectDirectory}\"");
                            directory_destroy(__projectDirectory);
                        }
                        
                        __projectPath      = _newProjectPath;
                        __projectDirectory = filename_dir(__projectPath) + "/";
                        __readOnly         = true;
                        __inCache          = true;
                        __converted        = true;
                        
                        __HotglueTrace($"Changed project path to \"{__projectPath}\"");
                        
                        var _buffer = buffer_load(__projectPath);
                        __yypString = buffer_read(_buffer, buffer_text);
                        buffer_delete(_buffer);
                        
                        __yypJson = json_parse(__yypString);
                    }
                }
            }
        }
        
        var _yyFoldersArray = __yypJson.Folders;
        var _i = 0;
        repeat(array_length(_yyFoldersArray))
        {
            __AddAsset(new __HotglueFolder(_yyFoldersArray[_i]));
            ++_i;
        }
        
        var _yyResourcesArray = __yypJson.resources;
        var _i = 0;
        repeat(array_length(_yyResourcesArray))
        {
            var _resource = _yyResourcesArray[_i].id;
            
            if (_resource.name == "hotglue_metadata")
            {
                try
                {
                    var _buffer = buffer_load(__projectDirectory + filename_change_ext(_resource.path, ".txt"));
                    var _string = buffer_read(_buffer, buffer_text);
                    buffer_delete(_buffer);
                    
                    __hotglueMetadata = json_parse(_string);
                    
                    if (__hotglueMetadata.version != 1)
                    {
                        throw "Hotglue version check failed";
                    }
                    
                    if (not is_array(__hotglueMetadata.installed))
                    {
                        throw "Hotglue metadata installed library record not an array";
                    }
                }
                catch(_error)
                {
                    LogWarning(json_stringify(_error, true));
                    LogWarning($"Could not read Hotglue metadata at \"{_resource.path}\"");
                    
                    __hotglueMetadata = undefined;
                }
            }
            else
            {
                var _constructor = __HotglueDetermineResourceConstructor(_resource.path);
                __AddAsset(new _constructor(_resource));
            }
            
            ++_i;
        }
        
        var _yyIncludedFilesArray = __yypJson.IncludedFiles;
        var _i = 0;
        repeat(array_length(_yyIncludedFilesArray))
        {
            __AddAsset(new __HotglueIncludedFile(_yyIncludedFilesArray[_i]));
            ++_i;
        }
        
        //Pretty up the asset array
        
        array_sort(__quickAssetArray, function(_a, _b)
        {
            return (_a.GetPID() < _b.GetPID())? -1 : 1;
        });
        
        __loadedSuccessfully = true;
    }
    
    static GetName = function()
    {
        return __yypJson.name;
    }
    
    static GetVersionString = function()
    {
        return is_struct(__yympsMetadata)? __yympsMetadata.version : "-.-.-";
    }
    
    static GetPath = function()
    {
        return __projectPath;
    }
    
    static GetDirectory = function()
    {
        return __projectDirectory;
    }
    
    static GetURL = function()
    {
        return __sourceURL;
    }
    
    static GetReadOnly = function()
    {
        return __readOnly;
    }
    
    static GetInCache = function()
    {
        return __inCache;
    }
    
    static GetConverted = function()
    {
        return __converted;
    }
    
    static GetYYPName = function()
    {
        return __yypJson.name;
    }
    
    static GetYYPVersion = function()
    {
        return __yypVersion;
    }
    
    static GetYYPOriginalVersion = function()
    {
        return __yypOriginalVersion;
    }
    
    static GetYYPVersionSupported = function(_version = __yypVersion)
    {
        return (is_string(_version) && (string_copy(_version, 1, 7) == "2024.14"));
    }
    
    static GetLoadedSuccessfully = function()
    {
        return __loadedSuccessfully;
    }
    
    static __DeleteGlobalReferences = function()
    {
        struct_remove(_projectByPathDict,  __projectPath);
        struct_remove(_projectBySourceURLDict, __sourceURL);
    }
    
    static GetHotglueMetadataExists = function()
    {
        return (__hotglueMetadata != undefined);
    }
    
    static EnsureHotglueMetadata = function()
    {
        if (__readOnly) return;
        if (__hotglueMetadata != undefined) return;
        
        __hotglueMetadata = __HotglueCreateMetadata();
        
        var _tempFilename = HOTGLUE_TEMP_CACHE_DIRECTORY + "hotglue_metadata.json";
        var _string = json_stringify(__hotglueMetadata, true);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, _tempFilename);
        buffer_delete(_buffer);
        
        var _looseFile = HotglueLoadLooseFile(_tempFilename);
        _looseFile.SetType("note");
        
        var _job = JobImportFromLooseFiles(_looseFile);
        _job.Execute();
        
        file_delete(_tempFilename);
    }
    
    static __SaveHotglueMetadata = function()
    {
        if (__readOnly) return;
        if (__hotglueMetadata == undefined) return;
        
        var _path = $"{__projectDirectory}notes/hotglue_metadata/hotglue_metadata.txt";
        
        if (not file_exists(_path))
        {
            EnsureHotglueMetadata();
            return;
        }
        
        var _string = json_stringify(__hotglueMetadata, true);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, _path);
        buffer_delete(_buffer);
    }
    
    static GetProjectStructure = function()
    {
        if (__structureDirty)
        {
            __structureDirty = false;
            __structure.Rebuild();
        }
        
        return __structure.GetRebuilding()? undefined : __structure;
    }
        
    static __AddAsset = function(_hotglueAsset)
    {
        array_push(__quickAssetArray, _hotglueAsset);
        __quickAssetDict[$ _hotglueAsset.GetPID()] = _hotglueAsset;
    }
    
    static __DeleteAsset = function(_assetPID)
    {
        var _asset = __quickAssetDict[$ _assetPID];
        if (is_struct(_asset))
        {
            _asset.__DeleteFromDisk(self);
            
            struct_remove(__quickAssetDict, _assetPID);
            var _index = array_get_index(__quickAssetArray, _asset);
            if (_index >= 0) array_delete(__quickAssetArray, _index, 1);
        }
    }
    
    static GetAssets = function()
    {
        var _array = [];
        
        var _quickAssetArray = __quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            array_push(_array, _quickAssetArray[_i].GetPID());
            ++_i;
        }
        
        return _array;
    }
    
    static GetAssetExists = function(_assetRef)
    {
        return variable_struct_exists(__quickAssetDict, _assetRef);
    }
    
    static GetImported = function()
    {
        static _emptyArray = [];
        return (__hotglueMetadata == undefined)? _emptyArray : __hotglueMetadata.installed;
    }
    
    static JobEmpty = function()
    {
        return new __HotglueJob(self);
    }
    
    static JobImportAllFrom = function(_sourceProject, _subfolder = "")
    {
        var _job = new __HotglueJob(self);
        _job.__QueueImportAllFrom(_sourceProject, _subfolder);
        return _job;
    }
    
    static JobImportAsLibrary = function(_sourceProject, _subfolder = "")
    {
        var _job = new __HotglueJob(self);
        _job.__QueueDeleteLibrary(_sourceProject.GetName());
        _job.__QueueAddLibrary(_sourceProject);
        return _job;
    }
    
    static JobDeleteLibrary = function(_libraryName)
    {
        var _job = new __HotglueJob(self);
        _job.__QueueDeleteLibrary(_libraryName);
        return _job;
    }
    
    static JobImportFrom = function(_sourceProject, _assetPIDArray, _subfolder = "")
    {
        //Convert PID array to array of actual asset structs
        var _quickAssetDict = _sourceProject.__quickAssetDict;
        var _assetArray = array_create(array_length(_assetPIDArray));
        var _i = 0;
        repeat(array_length(_assetPIDArray))
        {
            _assetArray[@ _i] = _quickAssetDict[$ _assetPIDArray[_i]];
            ++_i;
        }
        
        var _job = new __HotglueJob(self);
        _job.__QueueImportFrom(_sourceProject, _assetArray, _subfolder);
        return _job;
    }
    
    static JobImportFromLooseFiles = function(_looseFileArray, _subfolder = "")
    {
        var _job = new __HotglueJob(self);
        _job.__QueueImportLooseFile(_looseFileArray, _subfolder);
        return _job;
    }
    
    static ImportAsLibrary = function(_sourceProject, _subfolder = "")
    {
        
    }
    
    static DeleteLibrary = function(_libraryName, _saveMetadata = true)
    {
        
    }
    
    static ImportFrom = function(_sourceProject, _assetNameArray, _subfolder = "")
    {
        
    }
    
    static ImportFromLooseFiles = function(_looseFileArray, _subfolder = "")
    {
        
    }
    
    static __GetLibraryMetadata = function(_libraryName)
    {
        if (not GetHotglueMetadataExists()) return undefined;
        
        var _installedArray = __hotglueMetadata.installed;
        var _i = 0;
        repeat(array_length(_installedArray))
        {
            if (_installedArray[_i].name == _libraryName)
            {
                return _installedArray[_i];
            }
            
            ++_i;
        }
        
        return undefined;
    }
    
    static VerifyLibrary = function(_libraryName)
    {
        if (not GetHotglueMetadataExists()) return -1;
        
        var _libraryMetadata = __GetLibraryMetadata(_libraryName);
        if (_libraryMetadata == undefined) return;
        
        var _installedPIDArray = _libraryMetadata.assets;
        var _quickAssetDict    = __quickAssetDict;
        
        var _result = 1;
        var _i = 0;
        repeat(array_length(_installedPIDArray))
        {
            var _pid = _installedPIDArray[_i];
            
            var _asset = _quickAssetDict[$ _pid];
            if (not is_struct(_asset))
            {
                _result = 0;
                __HotglueWarning($"Missing {_pid}");
            }
            
            ++_i;
        }
        
        return _result;
    }
    
    static __VerifyFilesUnzipped = function()
    {
        var _emptyBuffer = buffer_create(0, buffer_fixed, 1);
        var _projectDirectory = filename_dir(__projectPath) + "/";
        
        var _fileArray = [];
        
        var _quickAssetArray = __quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            _quickAssetArray[_i].__GetFiles(self, _fileArray);
            ++_i;
        }
        
        var _filesMissing = 0;
        var _i = 0;
        repeat(array_length(_fileArray))
        {
            var _path = _projectDirectory + _fileArray[_i];
            if (not file_exists(_path))
            {
                __HotglueWarning($"\"{_path}\" not found, creating an empty file in its place");
                buffer_save(_emptyBuffer, _path);
                
                ++_filesMissing;
            }
            
            ++_i;
        }
        
        if (_filesMissing > 0)
        {
            __HotglueWarning($"Expecting {array_length(_fileArray)} file(s), {_filesMissing} file(s) were missing");
        }
        
        buffer_delete(_emptyBuffer);
    }
    
    static __VerifyIncludedFilesExist = function()
    {
        var _projectDirectory = filename_dir(__projectPath) + "/";
        
        var _filesExpected = 0;
        var _filesMissing = 0;
        
        var _quickAssetArray = __quickAssetArray;
        var _quickAssetDict  = __quickAssetDict;
        
        var _i = array_length(_quickAssetArray)-1;
        repeat(array_length(_quickAssetArray))
        {
            var _asset = _quickAssetArray[_i];
            
            if (_asset.type == "included file")
            {
                ++_filesExpected;
                
                var _path = _projectDirectory + _asset.path;
                if (not file_exists(_path))
                {
                    __HotglueWarning($"Warning! \"{_path}\" not found, removing from project manifest");
                    ++_filesMissing;
                    
                    array_delete(_quickAssetArray, _i, 1);
                    variable_struct_remove(_quickAssetDict, _asset.GetPID());
                }
            }
            
            --_i;
        }
        
        if (_filesMissing > 0)
        {
            __HotglueWarning($"Expecting {_filesExpected} included file(s), {_filesMissing} file(s) were missing");
        }
    }
    
    static __SetYYMPSMetadata = function(_yympsMetadata)
    {
        __yympsMetadata = _yympsMetadata;
        return self;
    }
}
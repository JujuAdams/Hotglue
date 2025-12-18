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
                var _buffer = buffer_load(__projectDirectory + filename_change_ext(_resource.path, ".txt"));
                var _string = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                
                __hotglueMetadata = json_parse(_string);
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
        return (__hotglueMetadata == undefined)? __yypJson.name : __hotglueMetadata[0].name;
    }
    
    static GetVersionString = function()
    {
        if (is_array(__hotglueMetadata) && (not __hotglueMetadata[0].yympsOverridesVersion))
        {
            with(__hotglueMetadata[0].version)
            {
                return $"{(major == "")? "0" : major}.{(minor == "")? "0" : minor}.{(patch == "")? "0" : patch}{(extension != "")? "-" : ""}{extension}";
            }
        }
        else if (is_struct(__yympsMetadata))
        {
            return __yympsMetadata.version;
        }
        
        return "0.0.0";
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
        
        __hotglueMetadata = __HotglueCreateMetadata(__yypJson.name);
        
        var _tempFilename = HOTGLUE_TEMP_CACHE_DIRECTORY + "hotglue_metadata.json";
        var _string = json_stringify(__hotglueMetadata, true);
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, _tempFilename);
        buffer_delete(_buffer);
        
        var _looseFile = HotglueLoadLooseFile(_tempFilename);
        _looseFile.SetType("note");
        
        ImportFromLooseFiles(_looseFile);
        
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
    
    static GetNonConflicting = function(_otherProject)
    {
        var _nonconflictArray = [];
        
        var _quickAssetArray = __quickAssetArray;
        var _otherAssetDict  = _otherProject.__quickAssetDict;
        
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            var _assetName = _quickAssetArray[_i].GetPID();
            if (not variable_struct_exists(_otherAssetDict, _assetName))
            {
                array_push(_nonconflictArray, _assetName);
            }
            
            ++_i;
        }
        
        return _nonconflictArray;
    }
    
    static GetConflicting = function(_otherProject)
    {
        return GetConflictingExt(_otherProject.__quickAssetArray);
    }
    
    static GetConflictingExt = function(_assetArray)
    {
        var _conflictArray = [];
        var _assetDict = __quickAssetDict;
        
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _assetPID = _assetArray[_i];
            if (variable_struct_exists(_assetDict, _assetPID))
            {
                array_push(_conflictArray, _assetPID);
            }
            
            ++_i;
        }
        
        return _conflictArray;
    }
    
    static GetConflictingLooseFiles = function(_looseFileArray)
    {
        var _conflictArray = [];
        var _assetDict = __quickAssetDict;
        
        var _i = 0;
        repeat(array_length(_looseFileArray))
        {
            var _assetPID = _looseFileArray[_i].GetPID();
            if (variable_struct_exists(_assetDict, _assetPID))
            {
                array_push(_conflictArray, _assetPID);
            }
            
            ++_i;
        }
        
        return _conflictArray;
    }
    
    static GetImported = function()
    {
        static _emptyArray = [];
        return (__hotglueMetadata == undefined)? _emptyArray : __hotglueMetadata[1];
    }
    
    static GetExpandedAssets = function(_assetArray) //TODO - Does this need to be wound into the conflict detectors?
    {
        if (not is_array(_assetArray))
        {
            _assetArray = [_assetArray];
        }
        
        var _visitedArray = variable_clone(_assetArray);
        var _visitedDict  = {};
        
        var _i = 0;
        repeat(array_length(_visitedArray))
        {
            _visitedDict[$ _visitedArray[_i]] = true;
            ++_i;
        }
        
        for(var _i = 0; _i < array_length(_visitedArray); ++_i) //Array length can change
        {
            var _assetName = _visitedArray[_i];
            
            var _asset = __quickAssetDict[$ _assetName];
            if (_asset == undefined)
            {
                __HotglueError($"Asset \"{_assetName}\" not found in project");
            }
            
            _asset.__GetExpandedAssets(self, _visitedArray, _visitedDict);
            
            ++_i;
        }
        
        return _visitedArray;
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
        _job.__QueueDeleteLibrary(_sourceProject);
        _job.__QueueAddLibrary(_sourceProject);
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
    
    static ImportFromLooseFiles = function(_looseFileArray, _subfolder = "")
    {
        var _job = new __HotglueJob(self);
        _job.__QueueImportLooseFile(_looseFileArray, _subfolder = "");
        return _job;
    }
    
    static ImportAsLibrary = function(_sourceProject, _subfolder = "")
    {
        if (__readOnly) return;
        
        DeleteLibrary(_sourceProject.GetName(), false);
        __AddLibrary(_sourceProject.GetName(), _sourceProject.GetVersionString(), _sourceProject.GetURL(), _sourceProject.__quickAssetArray);
        __SaveHotglueMetadata();
        
        return ImportAllFrom(_sourceProject, _subfolder);
    }
    
    static __GetLibraryMetadata = function(_libraryName)
    {
        if (not GetHotglueMetadataExists()) return undefined;
        
        var _installedArray = __hotglueMetadata[1];
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
    
    static __AddLibrary = function(_libraryName, _version, _origin, _assetArray)
    {
        if (__readOnly) return;
        if (not GetHotglueMetadataExists()) return;
        
        var _assetPIDArray = array_create(array_length(_assetArray));
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            _assetPIDArray[@ _i] = _assetArray[_i].GetPID();
            ++_i;
        }
        
        array_push(__hotglueMetadata[1], {
            name:    _libraryName,
            version: _version,
            origin:  _origin,
            assets:  _assetPIDArray,
        });
    }
    
    static DeleteLibrary = function(_libraryName, _saveMetadata = true)
    {
        if (__readOnly) return;
        if (not GetHotglueMetadataExists()) return;
        
        var _libraryMetadata = __GetLibraryMetadata(_libraryName);
        if (_libraryMetadata == undefined) return;
        
        var _index = array_get_index(__hotglueMetadata[1], _libraryMetadata);
        if (_index >= 0) array_delete(__hotglueMetadata[1], _index, 1);
        
        var _installedPIDArray = _libraryMetadata.assets;
        var _i = 0;
        repeat(array_length(_installedPIDArray))
        {
            __DeleteAsset(_installedPIDArray[_i]);
            ++_i;
        }
        
        if (_saveMetadata)
        {
            __SaveHotglueMetadata();
        }
    }
    
    static ImportFrom = function(_sourceProject, _assetNameArray, _subfolder = "")
    {
        if (__readOnly) return;
        
        if (not is_array(_assetNameArray))
        {
            _assetNameArray = [_assetNameArray];
        }
        
        var _quickAssetDict = _sourceProject.__quickAssetDict;
        var _expandedAssetNameArray = _sourceProject.GetExpandedAssets(_assetNameArray);
        
        var _assetArray = array_create(array_length(_expandedAssetNameArray));
        var _i = 0;
        repeat(array_length(_expandedAssetNameArray))
        {
            _assetArray[@ _i] = _quickAssetDict[$ _expandedAssetNameArray[_i]];
            ++_i;
        }
        
        return __ImportFromProject(_sourceProject, _assetArray, _subfolder);
    }
    
    static __ImportFromProject = function(_sourceProject, _assetArray, _subfolder = "")
    {
        if (__readOnly) return;
        
        // 1. Ensure the user has Git set up
        __HotglueAssertGit(__projectDirectory);
        
        if (_subfolder != "")
        {
            __EnsureFolderPath(_subfolder);
        }
        
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _sourceHotglueAsset = _assetArray[_i];
            
            if ((_sourceHotglueAsset.type != "folder") && GetAssetExists(_sourceHotglueAsset.GetPID()))
            {
                __HotglueError($"Asset \"{_sourceHotglueAsset.GetPID()}\" already exists in project \"{GetPath()}\"");
            }
            
            if (_sourceHotglueAsset.GetPID() != "resource:hotglue_metadata")
            {
                // 3. Copy files on disk
                _sourceHotglueAsset.__Copy(self, _sourceProject);
                
                // 4. Duplicate the asset representation
                var _newHotglueAsset = variable_clone(_sourceHotglueAsset);
                
                // 5. Fix folder references in the .yy
                _newHotglueAsset.__FixYYReferences(self, _subfolder);
                
                // 6. Insert reference into .yyp
                _newHotglueAsset.__InsertIntoYYP(self, _subfolder);
                
                // 7. Formally add the new asset to this project representation
                __AddAsset(_newHotglueAsset);
            }
            
            ++_i;
        }
        
        // 8. Save updated .yyp
        var _buffer = buffer_create(string_byte_length(__yypString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, __yypString);
        buffer_save(_buffer, __projectPath);
        buffer_delete(_buffer);
        
        __structureDirty = true;
    }
    
    static ImportFromLooseFiles = function(_looseFileArray, _subfolder = "")
    {
        if (__readOnly) return;
        
        if (not is_array(_looseFileArray))
        {
            _looseFileArray = [_looseFileArray];
        }
        
        // 1. Ensure the user has Git set up
        __HotglueAssertGit(__projectDirectory);
        
        if (_subfolder != "")
        {
            __EnsureFolderPath(_subfolder);
        }
        
        var _i = 0;
        repeat(array_length(_looseFileArray))
        {
            var _looseFile = _looseFileArray[_i];
            
            __HotglueTrace($"Importing \"{_looseFile.GetPath()}\" as {_looseFile.GetType()} \"{_looseFile.GetName()}\"");
            
            // 2. Generate an asset
            var _asset = _looseFile.__GenerateAsset(self);
            
            if (GetAssetExists(_asset.GetPID()))
            {
                __HotglueError($"Asset \"{_asset.GetPID()}\" already exists in project \"{GetPath()}\"");
            }
            
            // 3. Create files on disk inside the project
            _looseFile.__CreateFilesOnDisk(self, _asset, _subfolder);
            
            // 4. Insert reference into .yyp
            _asset.__InsertIntoYYP(self, ""); //Don't need a subfolder here because we generate a correct folder path already
            
            if (_asset.GetPID() != "resource:hotglue_metadata")
            {
                // 5. Formally add the new asset to this project representation
                __AddAsset(_asset);
            }
            
            ++_i;
        }
        
        // 6. Save updated .yyp
        var _buffer = buffer_create(string_byte_length(__yypString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, __yypString);
        buffer_save(_buffer, __projectPath);
        buffer_delete(_buffer);
        
        __structureDirty = true;
    }
    
    static __EnsureFolderPath = function(_inPath)
    {
        if (__readOnly) return;
        if (_inPath == "")
        {
            //The root always exists
            return;
        }
        
        //Sanitize
        var _path = string_replace_all(_inPath, "\\", "/");
        
        //Iterate over every stage in the path to ensure we have all the folders set up along the path
        repeat(string_count("/", _path) + 1)
        {
            if (not variable_struct_exists(__quickAssetDict, $"folder:{_path}"))
            {
                var _hotglueAsset = new __HotglueFolder({ folderPath: $"folders/{_path}.yy", name: filename_name(_path), });
                _hotglueAsset.__InsertIntoYYP(self, "");
                __AddAsset(_hotglueAsset);
            }
            
            _path = filename_dir(_path);
        }
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
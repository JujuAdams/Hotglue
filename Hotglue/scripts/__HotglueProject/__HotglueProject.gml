// Feather disable all

/// @param projectPath

function __HotglueProject(_projectPath) constructor
{
    __HotglueTrace($"Creating project representation \"{_projectPath}\"");
    
    if (not file_exists(_projectPath))
    {
        __HotglueError($"\"{_projectPath}\" doesn't exist");
    }
    
    __projectPath = _projectPath;
    __projectDirectory = filename_dir(__projectPath) + "/";
    
    __quickAssetArray = [];
    __quickAssetDict  = {};
    
    ///////
    // Load project .yyp
    ///////
    
    var _buffer = buffer_load(_projectPath);
    __yypString = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    
    __yypJson = json_parse(__yypString);
    
    static __AddAsset = function(_hotglueAsset)
    {
        array_push(__quickAssetArray, _hotglueAsset);
        __quickAssetDict[$ _hotglueAsset.name] = _hotglueAsset;
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
        var _constructor = __HotglueDetermineResourceConstructor(_resource.path);
        __AddAsset(new _constructor(_resource));
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
        return (_a.name < _b.name)? -1 : 1;
    });
    
    __structure = new __HotglueProjectStructure(self);
    __structureDirty = true;
    
    
    
    static GetName = function()
    {
        return __yypJson.name;
    }
    
    static GetPath = function()
    {
        return __projectPath;
    }
    
    static GetDirectory = function()
    {
        return __projectDirectory;
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
    
    static GetAssets = function()
    {
        var _array = [];
        
        var _quickAssetArray = __quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            array_push(_array, _quickAssetArray[_i].name);
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
            var _assetName = _quickAssetArray[_i].name;
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
        var _conflictArray = [];
        
        var _quickAssetArray = __quickAssetArray;
        var _otherAssetDict  = _otherProject.__quickAssetDict;
        
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            var _assetName = _quickAssetArray[_i].name;
            if (variable_struct_exists(_otherAssetDict, _assetName))
            {
                array_push(_conflictArray, _assetName);
            }
            
            ++_i;
        }
        
        return _conflictArray;
    }
    
    static GetExpandedAssets = function(_assetArray)
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
    
    static ImportAllFrom = function(_sourceProject, _subfolder = "")
    {
        return __ImportFromProject(_sourceProject, _sourceProject.__quickAssetArray, _subfolder);
    }
    
    static ImportFrom = function(_sourceProject, _assetNameArray, _subfolder = "")
    {
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
            
            if ((_sourceHotglueAsset.type != "folder") && GetAssetExists(_sourceHotglueAsset.name))
            {
                __HotglueError($"Asset \"{_sourceHotglueAsset.name}\" already exists in project \"{GetPath()}\"");
            }
            
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
            
            if (GetAssetExists(_asset.name))
            {
                __HotglueError($"Asset \"{_asset.name}\" already exists in project \"{GetPath()}\"");
            }
            
            // 3. Create files on disk inside the project
            _looseFile.__CreateFilesOnDisk(self, _asset, _subfolder);
            
            // 4. Insert reference into .yyp
            _asset.__InsertIntoYYP(self, ""); //Don't need a subfolder here because we generate a correct folder path already
            
            // 5. Formally add the new asset to this project representation
            __AddAsset(_asset);
            
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
                    variable_struct_remove(_quickAssetDict, _asset.name);
                }
            }
            
            --_i;
        }
        
        if (_filesMissing > 0)
        {
            __HotglueWarning($"Expecting {_filesExpected} included file(s), {_filesMissing} file(s) were missing");
        }
    }
}
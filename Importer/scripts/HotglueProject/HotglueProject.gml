// Feather disable all

/// @param projectPath

function HotglueProject(_projectPath) constructor
{
    __HotglueTrace($"Creating project representation \"{_projectPath}\"");
    
    if (not file_exists(_projectPath))
    {
        __HotglueError($"\"{_projectPath}\" doesn't exist");
    }
    
    __projectPath = _projectPath;
    
    __quickAssetArray = [];
    __quickAssetDict  = {};
    
    ///////
    // Load project .yyp
    ///////
    
    var _buffer = buffer_load(_projectPath);
    __yypString = buffer_read(_buffer, buffer_text);
    __yypTextDirty = false;
    buffer_delete(_buffer);
    
    __yypJson = json_parse(__yypString);
    
    ///////
    // Folders
    ///////
    
    var _yyFoldersArray = __yypJson.Folders;
    var _i = 0;
    repeat(array_length(_yyFoldersArray))
    {
        var _folder = _yyFoldersArray[_i];
        
        var _hotglueAsset = new __HotglueFolder(_folder);
        __AddAsset(_hotglueAsset);
        
        ++_i;
    }
    
    ///////
    // Resources (scripts, rooms, objects, etc.)
    ///////
    
    var _yyResourcesArray = __yypJson.resources;
    var _i = 0;
    repeat(array_length(_yyResourcesArray))
    {
        var _resource = _yyResourcesArray[_i].id;
        
        var _constructor = __HotglueDetermineResourceConstructor(_resource.path);
        var _hotglueAsset = new _constructor(_resource);
        __AddAsset(_hotglueAsset);
        
        ++_i;
    }
    
    ///////
    // Included Files
    ///////
    
    var _yyIncludedFilesArray = __yypJson.IncludedFiles;
    var _i = 0;
    repeat(array_length(_yyIncludedFilesArray))
    {
        var _includedFile = _yyIncludedFilesArray[_i];
        
        var _hotglueAsset = new __HotglueIncludedFile(_includedFile);
        __AddAsset(_hotglueAsset);
        
        ++_i;
    }
    
    array_sort(__quickAssetArray, function(_a, _b)
    {
        return (_a.name < _b.name)? -1 : 1;
    });
    
    static __AddAsset = function(_hotglueAsset)
    {
        array_push(__quickAssetArray, _hotglueAsset);
        __quickAssetDict[$ _hotglueAsset.name] = _hotglueAsset;
    }
    
    
    
    
    
    static GetPath = function()
    {
        return __projectPath;
    }
    
    static GetAssetArray = function()
    {
        return __quickAssetArray;
    }
    
    static GetAssetExists = function(_target)
    {
        return variable_struct_exists(__quickAssetDict, _target);
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
    
    static ImportAll = function(_otherProject)
    {
        var _sourceDirectory = filename_dir(_otherProject.__projectPath) + "/";
        var _destinationDirectory = filename_dir(__projectPath) + "/";
        
        // 1. Ensure the user has Git set up
        __HotglueAssertGit(_destinationDirectory);
        
        var _assetArray = _otherProject.__quickAssetArray;
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _sourceHotglueAsset = _assetArray[_i];
            
            if (GetAssetExists(_sourceHotglueAsset.name))
            {
                __HotglueError($"Asset \"{_sourceHotglueAsset.name}\" already exists in project \"{GetPath()}\"");
            }
            
            // 2. Copy raw files
            _sourceHotglueAsset.__Copy(_sourceDirectory, _destinationDirectory);
            var _newHotglueAsset = variable_clone(_sourceHotglueAsset);
            
            // 3. Fix folder references in the .yy
            _newHotglueAsset.__FixYYReferences(self);
            
            // 4. Insert reference into .yyp
            _newHotglueAsset.__InsertIntoYYP(self);
            
            // 5. Formally add the new asset to our internal tracking
            if (_newHotglueAsset.implemented)
            {
                __AddAsset(_newHotglueAsset);
            }
            
            ++_i;
        }
        
        // 6. Save updated .yyp
        SaveYYPIfDirty(true);
    }
    
    static ImportSingle = function(_otherProject, _assetName)
    {
        if (GetAssetExists(_assetName))
        {
            __HotglueError($"Asset \"{_assetName}\" already exists in project \"{GetPath()}\"");
        }
        
        if (not _otherProject.GetAssetExists(_assetName))
        {
            __HotglueError($"Asset \"{_assetName}\" doesn't exists in project \"{_otherProject.GetPath()}\"");
        }
        
        var _sourceDirectory = filename_dir(_otherProject.__projectPath) + "/";
        var _destinationDirectory = filename_dir(__projectPath) + "/";
        
        var _sourceHotglueAsset = _otherProject.__quickAssetDict[$ _assetName];
        
        // 1. Ensure the user has Git set up
        __HotglueAssertGit(_destinationDirectory);
        
        // 2. Copy raw files
        _sourceHotglueAsset.__Copy(_sourceDirectory, _destinationDirectory);
        var _newHotglueAsset = variable_clone(_sourceHotglueAsset);
        
        // 3. Fix folder references in the .yy
        _newHotglueAsset.__FixYYReferences(self);
        
        // 4. Insert reference into .yyp
        _newHotglueAsset.__InsertIntoYYP(self);
        
        // 5. Formally add the new asset to our internal tracking
        if (_newHotglueAsset.implemented)
        {
            __AddAsset(_newHotglueAsset);
        }
        
        // 6. Save updated .yyp
        SaveYYPIfDirty(true);
    }
    
    static SaveYYPIfDirty = function(_force = false)
    {
        if ((not __yypTextDirty) && (not _force)) return;
        __yypTextDirty = false;
        
        var _buffer = buffer_create(string_byte_length(__yypString), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, __yypString);
        buffer_save(_buffer, __projectPath);
        buffer_delete(_buffer);
    }
    
    static EnsureFolderPath = function(_inPath)
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
                _hotglueAsset.__InsertIntoYYP(self);
                __AddAsset(_hotglueAsset);
            }
            
            _path = filename_dir(_path);
        }
    }
    
    static __VerifyFilesUnzipped = function()
    {
        var _emptyBuffer = buffer_create(0, buffer_fixed, 1);
        var _projectDirectory = filename_dir(__projectPath) + "/";
        
        var _quickAssetArray = __quickAssetArray;
        var _i = 0;
        repeat(array_length(_quickAssetArray))
        {
            _quickAssetArray[_i].__VerifyFileUnzipped(_projectDirectory, _emptyBuffer);
            ++_i;
        }
        
        buffer_delete(_emptyBuffer);
    }
}
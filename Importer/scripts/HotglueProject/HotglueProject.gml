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
    __yypText = buffer_read(_buffer, buffer_text);
    __yypTextDirty = false;
    buffer_delete(_buffer);
    
    __yypJson = json_parse(__yypText);
    
    ///////
    // Folders
    ///////
    
    var _yyFoldersArray = __yypJson.Folders;
    var _i = 0;
    repeat(array_length(_yyFoldersArray))
    {
        var _folder = _yyFoldersArray[_i];
        
        var _hotglueAsset = {
            name: $"folder:{__HotglueProcessFolderPath(_folder.folderPath)}",
            type: "folder",
            data: _folder,
        };
        
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
        
        var _resourceType = __HotglueDetermineResourceType(_resource.path);
        if (_resourceType == "unknown")
        {
            __HotglueTrace($"Warning! Resource \"{_resource.path}\" has an unhandled type");
        }
        
        var _hotglueAsset = {
            name: $"resource:{_resource.name}",
            type: "resource",
            data: _resource,
            resourceType: _resourceType,
        };
        
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
        
        var _includedFileName = _includedFile.filePath + "/" + _includedFile.name;
        if (string_copy(_includedFileName, 1, 10) == "datafiles/")
        {
            _includedFileName = string_delete(_includedFileName, 1, 10);
        }
        
        var _hotglueAsset = {
            name: $"included file:{_includedFileName}",
            type: "included file",
            data: _includedFile,
        };
        
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
        var _projectDirectory = filename_dir(__projectPath) + "/";
        
        var _assetArray = _otherProject.__quickAssetArray;
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _sourceHotglueAsset = _assetArray[_i];
            
            if (GetAssetExists(_sourceHotglueAsset.name))
            {
                __HotglueError($"Asset \"{_sourceHotglueAsset.name}\" already exists in project \"{GetPath()}\"");
            }
            
            var _newHotglueAsset = variable_clone(_sourceHotglueAsset);
            
            // 1. Ensure the user has Git set up
            __HotglueAssertGit(_projectDirectory);
            
            // 2. Copy raw files
            __HotglueCopyAsset(__projectPath, _otherProject.__projectPath, _sourceHotglueAsset);
            
            // 3. Fix folder references in the .yy
            __HotglueFixYYReferences(self, _newHotglueAsset);
            
            // 4. Insert reference into .yyp
            __HotglueInsertIntoYYP(self, _newHotglueAsset);
            
            ++_i;
        }
        
        // 5. Save updated .yyp
        SaveYYPIfDirty();
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
        
        var _projectDirectory = filename_dir(__projectPath) + "/";
        var _sourceHotglueAsset = _otherProject.__quickAssetDict[$ _assetName];
        
        var _newHotglueAsset = variable_clone(_sourceHotglueAsset);
        
        // 1. Ensure the user has Git set up
        __HotglueAssertGit(_projectDirectory);
        
        // 2. Copy raw files
        __HotglueCopyAsset(__projectPath, _otherProject.__projectPath, _sourceHotglueAsset);
        
        // 3. Fix folder references in the .yy
        __HotglueFixYYReferences(self, _newHotglueAsset);
        
        // 4. Insert reference into .yyp
        __HotglueInsertIntoYYP(self, _newHotglueAsset);
        
        // 5. Save updated .yyp
        SaveYYPIfDirty();
    }
    
    static SaveYYPIfDirty = function()
    {
        if (not __yypTextDirty) return;
        __yypTextDirty = false;
        
        var _buffer = buffer_create(string_byte_length(__yypText), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, __yypText);
        buffer_save(_buffer, __projectPath);
        buffer_delete(_buffer);
    }
    
    static EnsureFolderPath = function(_inPath)
    {
        if (_inPath == "")
        {
            //The root always exists, duh
            return;
        }
        
        //Sanitize
        var _path = string_replace_all(_inPath, "\\", "/");
        
        //Iterate over every stage in the path to ensure we have all the folders set up along the path
        repeat(string_count("/", _path) + 1)
        {
            if (not variable_struct_exists(__quickAssetDict, $"folder:{_path}"))
            {
                var _hotglueAsset = {
                    name: $"folder:{_path}",
                    type: "folder",
                    data: {
                        name: filename_name(_path),
                        folderPath: $"folders/{_path}.yy",
                    },
                };
                
                __HotglueInsertIntoYYP(self, _hotglueAsset);
            }
            
            _path = filename_dir(_path);
        }
    }
}
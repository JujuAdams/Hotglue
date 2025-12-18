// Feather disable all

/// @param destinationProject

function __HotglueJob(_destinationProject) constructor
{
    __destinationProject = _destinationProject;
    
    __actionArray = [];
    __saveHotglueMetadata = false;
    
    __addPIDArray    = [];
    __addPIDDict     = {};
    __deletePIDArray = [];
    
    __derivedConflictPIDArray  = [];
    __derivedOverwritePIDArray = [];
    
    
    
    static GetAddArray = function()
    {
        return __addPIDArray;
    }
    
    static GetDeleteArray = function()
    {
        return __deletePIDArray;
    }
    
    static GetConflictArray = function()
    {
        return __derivedConflictPIDArray;
    }
    
    static GetOverwriteArray = function()
    {
        return __derivedOverwritePIDArray;
    }
    
    static __QueueImportAllFrom = function(_sourceProject, _subfolder = "")
    {
        return __QueueImportFrom(_sourceProject, _sourceProject.__quickAssetArray, _subfolder);
    }
    
    static __QueueImportFrom = function(_sourceProject, _assetArray, _subfolder = "")
    {
        __QueueEnsureFolderPath(_subfolder);
        
        if (not is_array(_assetArray))
        {
            _assetArray = [ _assetArray ];
        }
        
        var _expandedPIDArray = [];
        var _assetPIDDict     = _sourceProject.__quickAssetDict;
        var _addPIDDict       = __addPIDDict;
        
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _asset = _assetArray[_i];
            
            var _pid = _asset.GetPID();
            if (not struct_exists(_addPIDDict, _pid))
            {
                array_push(_expandedPIDArray, _pid);
                _asset.__GetExpandedAssets(_sourceProject, _expandedPIDArray, _addPIDDict);
                
                var _j = 0;
                repeat(array_length(_expandedPIDArray))
                {
                    var _pid = _expandedPIDArray[_j];
                    var _asset = _assetPIDDict[$ _pid];
                    
                    if (_asset == undefined)
                    {
                        __HotglueError($"Failed to find \"{_pid}\" in source project.\nWas this asset PID created from an improper expansion?");
                    }
                    
                    var _method = method(
                    {
                        __sourceProject: _sourceProject,
                        __asset:         _asset,
                        __subfolder:     _subfolder,
                    },
                    function(_destinationProject)
                    {
                        var _asset = __asset;
                    
                        if ((_asset.type != "folder") && _destinationProject.GetAssetExists(_asset.GetPID()))
                        {
                            __HotglueError($"Asset \"{_asset.GetPID()}\" already exists in project \"{GetPath()}\"");
                        }
                    
                        if (_asset.GetPID() != "resource:hotglue_metadata")
                        {
                            _asset.__Copy(_destinationProject, __sourceProject);
                        
                            var _newHotglueAsset = variable_clone(_asset);
                            _newHotglueAsset.__FixYYReferences(_destinationProject, __subfolder);
                            _newHotglueAsset.__InsertIntoYYP(_destinationProject, __subfolder);
                        
                            _destinationProject.__AddAsset(_newHotglueAsset);
                        }
                    });
                
                    array_push(__actionArray, _method);
                    array_push(__addPIDArray, _pid);
                    _addPIDDict[$ _pid] = true;
                    
                    ++_j;
                }
                
                array_resize(_expandedPIDArray, 0);
            }
            
            ++_i;
        }
    }
    
    static __QueueImportLooseFile = function(_looseFileArray, _subfolder = "")
    {
        __QueueEnsureFolderPath(_subfolder);
        
        if (not is_array(_looseFileArray))
        {
            _looseFileArray = [ _looseFileArray ];
        }
        
        var _addPIDDict = __addPIDDict;
        
        var _i = 0;
        repeat(array_length(_looseFileArray))
        {
            var _looseFile = _looseFileArray[_i];
            var _pid = _looseFile.GetPID();
            
            var _method = method(
            {
                __looseFile: _looseFile,
                __subfolder: _subfolder,
            },
            function(_destinationProject)
            {
                var _looseFile = __looseFile;
                
                __HotglueTrace($"Importing \"{_looseFile.GetPath()}\" as {_looseFile.GetType()} \"{_looseFile.GetName()}\"");
            
                var _asset = _looseFile.__GenerateAsset(_destinationProject);
            
                if (_destinationProject.GetAssetExists(_asset.GetPID()))
                {
                    __HotglueError($"Asset \"{_asset.GetPID()}\" already exists in project \"{_looseFile.GetPath()}\"");
                }
                
                _looseFile.__CreateFilesOnDisk(_destinationProject, _asset, __subfolder);
                    
                _asset.__InsertIntoYYP(_destinationProject, ""); //Don't need a subfolder here because we generate a correct folder path already
                    
                if (_asset.GetPID() != "resource:hotglue_metadata")
                {
                    _destinationProject.__AddAsset(_asset);
                }
            });
            
            array_push(__actionArray, _method);
            array_push(__addPIDArray, _pid);
            _addPIDDict[$ _pid] = true;
            
            ++_i;
        }
    }
    
    static __QueueEnsureFolderPath = function(_subfolder)
    {
        if (_subfolder == "")
        {
            //The root always exists
            return;
        }
        
        var _addPIDDict = __addPIDDict;
        
        //Sanitize
        var _path = string_replace_all(_subfolder, "\\", "/");
        
        //Iterate over every stage in the path to ensure we have all the folders set up along the path
        repeat(string_count("/", _path) + 1)
        {
            var _method = method(
            {
                __path: _path,
            },
            function(_destinationProject)
            {
                var _quickAssetDict = _destinationProject.__quickAssetDict;
                var _path = __path;
                
                if (not variable_struct_exists(_quickAssetDict, $"folder:{_path}"))
                {
                    var _hotglueAsset = new __HotglueFolder({ folderPath: $"folders/{_path}.yy", name: filename_name(_path), });
                    _hotglueAsset.__InsertIntoYYP(_destinationProject, "");
                    _destinationProject.__AddAsset(_hotglueAsset);
                }
            });
            
            var _pid = $"folder:{__HotglueProcessFolderPath($"folders/{_path}.yy")}";
            
            array_push(__actionArray, _method);
            array_push(__addPIDArray, _pid);
            _addPIDDict[$ _pid] = true;
            
            _path = filename_dir(_path);
        }
    }
    
    static __QueueDelete = function(_assetPIDArray)
    {
        if (not is_array(_assetPIDArray))
        {
            _assetPIDArray = [ _assetPIDArray ];
        }
        
        var _i = 0;
        repeat(array_length(_assetPIDArray))
        {
            var _pid = _assetPIDArray[_i];
            
            var _method = method(
            {
                __pid: _pid,
            },
            function(_destinationProject)
            {
                _destinationProject.__DeleteAsset(__pid);
            });
            
            array_push(__actionArray, _method);
            array_push(__deletePIDArray, _pid);
            
            ++_i;
        }
    }
    
    static __QueueDeleteLibrary = function(_libraryName)
    {
        var _libraryMetadata = __destinationProject.__GetLibraryMetadata(_libraryName);
        if (_libraryMetadata == undefined) return;
        
        __saveHotglueMetadata = true;
        
        __QueueDelete(_libraryMetadata.assets);
        
        var _method = method(
        {
            __libraryName: _libraryName,
        },
        function(_destinationProject)
        {
            var _libraryMetadata = _destinationProject.__GetLibraryMetadata(__libraryName);
            if (_libraryMetadata == undefined)
            {
                __HotglueWarning($"Cannot delete library \"{__libraryName}\", it doesn't exist in destination project");
            }
            else
            {
                var _index = array_get_index(_destinationProject.__hotglueMetadata[1], _libraryMetadata);
                if (_index >= 0) array_delete(_destinationProject.__hotglueMetadata[1], _index, 1);
            }
        });
        
        array_push(__actionArray, _method);
    }
    
    static __QueueAddLibrary = function(_sourceProject, _subfolder = "")
    {
        __saveHotglueMetadata = true;
        
        __QueueImportFrom(_sourceProject, _sourceProject.__quickAssetArray, _subfolder);
        
        var _method = method(
        {
            __sourceProject: _sourceProject,
        },
        function(_destinationProject)
        {
            var _sourceProject = __sourceProject;
            var _libraryName   = _sourceProject.GetName();
            var _versionString = _sourceProject.GetVersionString();
            var _originURL     = _sourceProject.GetURL();
            var _assetPIDArray = variable_clone(_sourceProject.__quickAssetArray); //FIXME - Generate PIDs
            
            var _libraryMetadata = _destinationProject.__GetLibraryMetadata(_libraryName);
            if (_libraryMetadata != undefined)
            {
                __HotglueWarning($"Cannot add library \"{_libraryName}\", it already exists in destination project");
            }
            else
            {
                array_push(_destinationProject.__hotglueMetadata[1], {
                    name:    _libraryName,
                    version: _versionString,
                    origin:  _originURL,
                    assets:  _assetPIDArray,
                });
            }
        });
        
        array_push(__actionArray, _method);
    }
    
    static BuildReport = function()
    {
        var _destinationPIDDict = __destinationProject.__quickAssetDict;
        
        var _addPIDArray       = __addPIDArray;
        var _addPIDDict        = __addPIDDict;
        var _deletePIDArray    = __deletePIDArray;
        var _conflictPIDArray  = __derivedConflictPIDArray;
        var _overwritePIDArray = __derivedOverwritePIDArray;
        
        array_resize(_conflictPIDArray,  0);
        array_resize(_overwritePIDArray, 0);
        
        var _deletePIDDict = {};
        var _i = 0;
        repeat(array_length(_deletePIDArray))
        {
            _deletePIDDict[$ _deletePIDArray[_i]] = true;
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_addPIDArray))
        {
            var _pid = _addPIDArray[_i];
            
            if (struct_exists(_deletePIDDict, _pid))
            {
                array_push(_overwritePIDArray, _pid);
                array_delete(_addPIDArray, _i, 1);
            }
            else if (struct_exists(_destinationPIDDict, _pid))
            {
                array_push(_conflictPIDArray, _pid);
                array_delete(_addPIDArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        var _i = 0;
        repeat(array_length(_deletePIDArray))
        {
            var _pid = _deletePIDArray[_i];
            
            if (struct_exists(_addPIDDict, _pid))
            {
                array_delete(_deletePIDArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
    }
    
    static Execute = function()
    {
        var _actionArray = __actionArray;
        with(__destinationProject)
        {
            if (__readOnly)
            {
                __HotglueWarning("Cannot execute job, destination project is read-only");
                return;
            }
            
            __HotglueAssertGit(__projectDirectory);
            
            if (other.__saveHotglueMetadata)
            {
                EnsureHotglueMetadata();
            }
            
            var _i = 0;
            repeat(array_length(_actionArray))
            {
                _actionArray[_i](self);
                ++_i;
            }
            
            var _buffer = buffer_create(string_byte_length(__yypString), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, __yypString);
            buffer_save(_buffer, __projectPath);
            buffer_delete(_buffer);
            
            if (other.__saveHotglueMetadata)
            {
                __SaveHotglueMetadata();
            }
            
            __structureDirty = true;
        }
    }
}
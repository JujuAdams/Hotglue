// Feather disable all

/// @param destinationProject

function __HotglueClassJob(_destinationProject) constructor
{
    __destinationProject = _destinationProject;
    
    __subfolder = "";
    
    __packageEdit    = false;
    __packageName    = "";
    __packageVersion = "";
    __packageURL     = "";
    
    __addPIDArray    = [];
    __addPIDDict     = {};
    __addActionArray = [];
    
    __derivedAddPIDArray       = [];
    __derivedDeletePIDArray    = [];
    __derivedConflictPIDArray  = [];
    __derivedOverwritePIDArray = [];
    
    
    
    static GetSubfolder = function()
    {
        return __subfolder;
    }
    
    static SetSubfolder = function(_subfolder)
    {
        __subfolder = _subfolder;
    }
    
    static GetAddArray = function()
    {
        return __derivedAddPIDArray;
    }
    
    static GetDeleteArray = function()
    {
        return __derivedDeletePIDArray;
    }
    
    static GetConflictArray = function()
    {
        return __derivedConflictPIDArray;
    }
    
    static GetOverwriteArray = function()
    {
        return __derivedOverwritePIDArray;
    }
    
    static SetPackageEdit = function(_state)
    {
        if (__packageEdit != _state)
        {
            __packageEdit = _state;
            BuildReport();
        }
    }
    
    static GetPackageEdit = function()
    {
        return __packageEdit;
    }
    
    static SetPackageName = function(_packageName)
    {
        if (__packageName != _packageName)
        {
            __packageName = _packageName;
            BuildReport();
        }
    }
    
    static GetPackageName = function()
    {
        return __packageName;
    }
    
    static SetPackageVersion = function(_packageVersion)
    {
        __packageVersion = _packageVersion;
    }
    
    static GetPackageVersion = function()
    {
        return __packageVersion;
    }
    
    static SetPackageURL = function(_packageURL)
    {
        __packageURL = _packageURL;
    }
    
    static GetPackageURL = function()
    {
        return __packageURL;
    }
    
    static SetPackageFromProject = function(_project)
    {
        __packageEdit = true;
            
        SetPackageName(_project.GetName() ?? "");
        SetPackageVersion(_project.GetVersionString() ?? "");
        SetPackageURL(_project.GetURL() ?? "");
    }
    
    static SetImportAllFrom = function(_sourceProject)
    {
        return SetImportFrom(_sourceProject, _sourceProject.__quickAssetArray);
    }
    
    static __ClearAdd = function()
    {
        __addPIDArray    = [];
        __addPIDDict     = {};
        __addActionArray = [];
    }
    
    static SetImportFrom = function(_sourceProject, _assetArray)
    {
        if (not is_array(_assetArray))
        {
            _assetArray = [ _assetArray ];
        }
        
        __ClearAdd();
        
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
                        __job: other,
                        __sourceProject: _sourceProject,
                        __asset: _asset,
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
                            _newHotglueAsset.__FixYYReferences(_destinationProject, __job.__subfolder);
                            _newHotglueAsset.__InsertIntoYYP(_destinationProject, __job.__subfolder);
                        
                            _destinationProject.__AddAsset(_newHotglueAsset);
                        }
                    });
                
                    array_push(__addActionArray, _method);
                    array_push(__addPIDArray, _pid);
                    _addPIDDict[$ _pid] = true;
                    
                    ++_j;
                }
                
                array_resize(_expandedPIDArray, 0);
            }
            
            ++_i;
        }
    }
    
    static SetImportLooseFile = function(_looseFileArray)
    {
        if (not is_array(_looseFileArray))
        {
            _looseFileArray = [ _looseFileArray ];
        }
        
        __ClearAdd();
        
        var _addPIDDict = __addPIDDict;
        
        var _i = 0;
        repeat(array_length(_looseFileArray))
        {
            var _looseFile = _looseFileArray[_i];
            var _pid = _looseFile.GetPID();
            
            var _method = method(
            {
                __job: other,
                __looseFile: _looseFile,
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
                
                _looseFile.__CreateFilesOnDisk(_destinationProject, _asset, __job.__subfolder);
                    
                _asset.__InsertIntoYYP(_destinationProject, ""); //Don't need a subfolder here because we generate a correct folder path already
                    
                if (_asset.GetPID() != "resource:hotglue_metadata")
                {
                    _destinationProject.__AddAsset(_asset);
                }
            });
            
            array_push(__addActionArray, _method);
            array_push(__addPIDArray, _pid);
            _addPIDDict[$ _pid] = true;
            
            ++_i;
        }
    }
    
    //static SetEnsureFolderPath = function(_subfolder)
    //{
    //    if (_subfolder == "")
    //    {
    //        //The root always exists
    //        return;
    //    }
    //    
    //    var _addPIDDict = __addPIDDict;
    //    
    //    //Sanitize
    //    var _path = string_replace_all(_subfolder, "\\", "/");
    //    
    //    //Iterate over every stage in the path to ensure we have all the folders set up along the path
    //    repeat(string_count("/", _path) + 1)
    //    {
    //        var _method = method(
    //        {
    //            __path: _path,
    //        },
    //        function(_destinationProject)
    //        {
    //            var _quickAssetDict = _destinationProject.__quickAssetDict;
    //            var _path = __path;
    //            
    //            if (not variable_struct_exists(_quickAssetDict, $"folder:{_path}"))
    //            {
    //                var _hotglueAsset = new __HotglueFolder({ folderPath: $"folders/{_path}.yy", name: filename_name(_path), });
    //                _hotglueAsset.__InsertIntoYYP(_destinationProject, "");
    //                _destinationProject.__AddAsset(_hotglueAsset);
    //            }
    //        });
    //        
    //        var _pid = $"folder:{__HotglueProcessFolderPath($"folders/{_path}.yy")}";
    //        
    //        array_push(__addActionArray, _method);
    //        array_push(__addPIDArray, _pid);
    //        _addPIDDict[$ _pid] = true;
    //        
    //        _path = filename_dir(_path);
    //    }
    //}
    
    static BuildReport = function()
    {
        var _destinationPIDDict = __destinationProject.__quickAssetDict;
        
        __derivedAddPIDArray = variable_clone(__addPIDArray);
        __derivedDeletePIDArray = [];
        
        if (__packageEdit)
        {
            var _hotglueMetadata = __destinationProject.EnsureHotglueMetadata();
            if (_hotglueMetadata != undefined)
            {
                var _libraryMetadata = __destinationProject.__GetLibraryMetadata(__packageName);
                if (_libraryMetadata != undefined)
                {
                    __derivedDeletePIDArray = variable_clone(_libraryMetadata.assets);
                }
            }
        }
        
        var _addPIDDict        = __addPIDDict;
        var _addPIDArray       = __derivedAddPIDArray;
        var _deletePIDArray    = __derivedDeletePIDArray;
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
        with(__destinationProject)
        {
            if (__readOnly)
            {
                __HotglueWarning("Cannot execute job, destination project is read-only");
                return;
            }
            
            __HotglueTrace("Starting job...");
            __structureDirty = true;
            
            __HotglueAssertGit(__projectDirectory);
            
            if (__packageEdit)
            {
                var _hotglueMetadata = EnsureHotglueMetadata();
                if (_hotglueMetadata != undefined)
                {
                    var _libraryMetadata = __GetLibraryMetadata(__packageName);
                    if (_libraryMetadata == undefined)
                    {
                        if (array_length(__addPIDArray) <= 0)
                        {
                            __HotglueWarning($"Cannot delete library \"{__libraryName}\", it doesn't exist in destination project");
                        }
                    }
                    else
                    {
                        __HotglueTrace($"\"{__libraryName}\" not found, not deleting anything");
                        
                        //Delete assets from the package
                        var _assetPIDArray = _libraryMetadata.assets;
                        var _i = 0;
                        repeat(array_length(_assetPIDArray))
                        {
                            __DeleteAsset(_assetPIDArray[_i]);
                            ++_i;
                        }
                        
                        //Remove reference from metadata
                        var _index = array_get_index(_hotglueMetadata.installed, _libraryMetadata);
                        if (_index >= 0) array_delete(_hotglueMetadata.installed, _index, 1);
                    }
                    
                    if (array_length(__addPIDArray) <= 0)
                    {
                        //Add the new package information to metadata
                        var _sourceAssetArray = __assetArray;
                        var _assetPIDArray = array_create(array_length(_sourceAssetArray));
                        var _i = 0;
                        repeat(array_length(_sourceAssetArray))
                        {
                            var _asset = _sourceAssetArray[_i];
                            _assetPIDArray[@ _i] = _asset.GetPID();
                            ++_i;
                        }
                        
                        array_push(_libraryMetadata.installed, {
                            name:    __libraryName,
                            version: __libraryVersion,
                            origin:  __libraryURL,
                            assets:  _assetPIDArray,
                        });
                    }
                    
                    __SaveHotglueMetadata();
                }
            }
            
            //Add assets (both copied from another project and loose files)
            var _addActionArray = other.__addActionArray;
            var _i = 0;
            repeat(array_length(_addActionArray))
            {
                _addActionArray[_i](self);
                ++_i;
            }
            
            //Save the new .yyp
            var _buffer = buffer_create(string_byte_length(__yypString), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, __yypString);
            buffer_save(_buffer, __projectPath);
            buffer_delete(_buffer);
            
            __HotglueTrace("...Job complete");
        }
    }
}
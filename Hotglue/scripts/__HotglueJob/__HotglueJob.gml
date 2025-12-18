// Feather disable all

/// @param destinationProject

function __HotglueJob(_destinationProject) constructor
{
    __destinationProject = _destinationProject;
    __actionArray = [];
    
    __addPIDArray       = [];
    __deletePIDArray    = [];
    __conflictPIDArray  = [];
    __overwritePIDArray = [];
    
    
    
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
        return __conflictPIDArray;
    }
    
    static GetOverwriteArray = function()
    {
        return __overwritePIDArray;
    }
    
    static __QueueImportAllFrom = function(_sourceProject, _subfolder = "")
    {
        return __QueueImportFrom(_sourceProject, _sourceProject.__quickAssetArray, _subfolder);
    }
    
    static __QueueImportFrom = function(_sourceProject, _assetArray, _subfolder = "")
    {
        if (not is_array(_assetArray))
        {
            _assetArray = [ _assetArray ];
        }
        
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _asset = _assetArray[_i];
            
            var _method = method(
            {
                __sourceProject: _sourceProject,
                __asset          _asset,
                __subfolder:     _subfolder,
            },
            function(_destinationProject)
            {
                var _asset = __asset;
                
                if ((_asset.type != "folder") && GetAssetExists(_asset.GetPID()))
                {
                    __HotglueError($"Asset \"{_asset.GetPID()}\" already exists in project \"{GetPath()}\"");
                }
                
                if (_asset.GetPID() != "resource:hotglue_metadata")
                {
                    _asset.__Copy(self, __sourceProject);
                    
                    var _newHotglueAsset = variable_clone(_asset);
                    _newHotglueAsset.__FixYYReferences(self, __subfolder);
                    _newHotglueAsset.__InsertIntoYYP(self, __subfolder);
                    
                    _destinationProject.__AddAsset(_newHotglueAsset);
                }
            });
            
            array_push(__actionArray, _method);
            array_push(__addPIDArray, _asset.GetPID());
            
            ++_i;
        }
    }
    
    static __QueueImportLooseFile = function(_looseFileArray, _subfolder = "")
    {
        if (not is_array(_looseFileArray))
        {
            _looseFileArray = [ _looseFileArray ];
        }
        
        var _i = 0;
        repeat(array_length(_looseFileArray))
        {
            var _method = method(
            {
                __looseFile: _looseFileArray[_i],
                __subfolder: _subfolder,
            },
            function(_destinationProject)
            {
                __HotglueTrace($"Importing \"{GetPath()}\" as {GetType()} \"{GetName()}\"");
            
                var _asset = __GenerateAsset(self);
            
                if (_destinationProject.GetAssetExists(_asset.GetPID()))
                {
                    __HotglueError($"Asset \"{_asset.GetPID()}\" already exists in project \"{GetPath()}\"");
                }
                
                __CreateFilesOnDisk(self, _asset, __subfolder);
                    
                _asset.__InsertIntoYYP(self, ""); //Don't need a subfolder here because we generate a correct folder path already
                    
                if (_asset.GetPID() != "resource:hotglue_metadata")
                {
                    _destinationProject.__AddAsset(_asset);
                }
            });
            
            array_push(__actionArray, _method);
            
            ++_i;
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
    
    static __QueueEnsureFolderPath = function(_subfolder)
    {
        if (_subfolder == "")
        {
            //The root always exists
            return;
        }
        
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
                    _hotglueAsset.__InsertIntoYYP(self, "");
                    _destinationProject.__AddAsset(_hotglueAsset);
                }
            });
            
            var _pid = $"folder:{__HotglueProcessFolderPath($"folders/{_path}.yy")}";
            
            array_push(__actionArray, _method);
            array_push(__addPIDArray, _pid);
            
            _path = filename_dir(_path);
        }
    }
    
    static BuildReport = function()
    {
        var _destinationPIDDict = __destinationProject.__quickAssetDict;
        
        var _addPIDArray       = __addPIDArray;
        var _deletePIDArray    = __deletePIDArray;
        var _conflictPIDArray  = __conflictPIDArray;
        var _overwritePIDArray = __overwritePIDArray;
        
        array_sort(_addPIDArray,    true);
        array_sort(_deletePIDArray, true);
        
        array_resize(_conflictPIDArray,  0);
        array_resize(_overwritePIDArray, 0);
        
        var _addPIDDict    = {};
        var _deletePIDDict = {};
        
        var _i = 0;
        repeat(array_length(_addPIDArray))
        {
            _addPIDDict[$ _addPIDArray[_i]] = true;
            ++_i;
        }
        
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
    
    static __ExecuteArray = function()
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
            
            __structureDirty = true;
        }
    }
}
// Feather disable all

/// @param project

function __HotglueProjectStructure(_project) constructor
{
    __project = _project;
    
    __rootNode = new __HotglueNodeProjectRoot(self);
    __includedFilesNode = new __HotglueNodeIncludedFilesRoot(self);
    
    __updateScope = {};
    with(__updateScope)
    {
        __structureWeakRef = weak_ref_create(other);
        
        __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            if (not weak_ref_alive(__structureWeakRef))
            {
                time_source_stop(__timeSource);
                time_source_destroy(__timeSource);
                return;
            }
            
            with(__structureWeakRef.ref)
            {
                if (__rebuilding)
                {
                    __RebuildProgressive();
                }
            }
        },
        [], -1);
        
        time_source_start(__timeSource);
    }
    
    __rebuilding = false;
    __rebuildIndex = 0;
    
    
    
    static Rebuild = function()
    {
        __rebuilding = true;
        __rebuildIndex = 0;
        
        __rootNode.__Clear();
        __includedFilesNode.__Clear();
        
        LogTraceAndStatus($"Rebuilding project structure for \"{__project.GetPath()}\"");
    }
    
    static GetRebuilding = function()
    {
        return __rebuilding;
    }
    
    static GetRebuildingProgress = function()
    {
        return __rebuilding? (__rebuildIndex / array_length(__project.__quickAssetArray)) : 1;
    }
    
    static __RebuildProgressive = function()
    {
        var _projectDirectory = __project.GetDirectory();
        var _assetArray = __project.__quickAssetArray;
        
        var _startTime = current_time;
        var _count = array_length(_assetArray);
        while((current_time - _startTime < 150) && (__rebuildIndex < _count))
        {
            var _asset = _assetArray[__rebuildIndex];
            var _assetType = _asset.type;
            var _assetPath = _asset.GetPath();
            
            if (_assetType == "resource")
            {
                var _buffer = buffer_load($"{_projectDirectory}{_assetPath}");
                var _yyString = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
                var _yyJSON = json_parse(_yyString);
                
                __EnsureFolderPath(__rootNode, $"{__HotglueProcessFolderPath(_yyJSON.parent.path)}/").__Add(new __HotglueNodeResource(_asset, self));
            }
            else if (_assetType == "folder")
            {
                __EnsureFolderPath(__rootNode, $"{_assetPath}/");
            }
            else if (_assetType == "included file")
            {
                __EnsureFolderPath(__includedFilesNode, _assetPath).__Add(new __HotglueNodeIncludedFile(_asset, self));
            }
            
            ++__rebuildIndex;
        }
        
        if (__rebuildIndex >= _count)
        {
            __rebuilding = false;
            LogTraceAndStatus($"Completed rebuild of project structure for \"{__project.GetPath()}\"");
        }
    }
    
    static __EnsureFolderPath = function(_rootNode, _path)
    {
        var _node = _rootNode;
        while(true)
        {
            var _pos = string_pos("/", _path);
            if (_pos <= 0) break;
            
            var _folderName = string_copy(_path, 1, _pos-1);
            _node = _node.__EnsureFolder(_folderName);
            
            _path = string_delete(_path, 1, _pos);
        }
        
        return _node;
    }
}
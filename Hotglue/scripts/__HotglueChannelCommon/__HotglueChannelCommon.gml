// Feather disable all

/// @param name
/// @param url
/// @param protected

function __HotglueChannelCommon(_name, _url, _protected) constructor
{
    static __type        = undefined;
    static __isFavorites = false;
    static __isRemote    = true;
    
    __name      = _name;
    __url       = _url;
    __protected = _protected;
    
    __repositoryArray = [];
    
    __refreshCallback = undefined;
    
    __HotglueTrace($"Channel \"{_name}\" created for \"{_url}\"");
    
    
    
    static GetName = function()
    {
        return __name;
    }
    
    static GetURL = function()
    {
        return __url;
    }
    
    static SerializeURLArray = function()
    {
        var _array = [];
        
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            var _repository = _repositoryArray[_i];
            array_push(_array, {
                url:  _repository.GetURL(),
                type: _repository.GetType(),
            });
            ++_i;
        }
        
        return _array;
    }
    
    static DeserializeURLArray = function(_inputArray)
    {
        var _repositoryArray = __repositoryArray;
        array_resize(_repositoryArray, 0);
        
        var _i = 0;
        repeat(array_length(_inputArray))
        {
            var _input = _inputArray[_i];
            if (is_struct(_input))
            {
                AddRepository(_input.url, _input[$ "type"]);
            }
            else
            {
                AddRepository(_input);
            }
            
            ++_i;
        }
    }
    
    static SortArray = function()
    {
        array_sort(__repositoryArray, function(_a, _b)
        {
            return (_a.GetName() < _b.GetName())? -1 : 1;
        });
    }
    
    static ClearRepositories = function()
    {
        array_resize(__repositoryArray, 0);
    }
    
    static AddRepository = function(_url, _forceType = undefined)
    {
        var _repository = GetRepositoryFromURL(_url);
        if (_repository == undefined)
        {
            _repository = HotglueEnsureRepositoryFromURL(self, _url, _forceType);
            array_push(__repositoryArray, _repository);
            LogTraceAndStatus($"Added repository \"{_url}\" to channel \"{__name}\"");
        }
        
        return _repository;
    }
    
    static DeleteRepository = function(_url)
    {
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            if (_repositoryArray[_i].GetURL() == _url)
            {
                array_delete(_repositoryArray, _i, 1);
                LogTraceAndStatus($"Deleted repository \"{_url}\" from channel \"{__name}\"");
                return;
            }
            
            ++_i;
        }
    }
    
    static GetRepositoryFromURL = function(_url)
    {
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            if (_repositoryArray[_i].GetURL() == _url)
            {
                return _repositoryArray[_i];
            }
            
            ++_i;
        }
        
        return undefined;
    }
    
    static GetRepositoryExists = function(_url)
    {
        return (GetRepositoryFromURL(_url) != undefined);
    }
    
    static GetRepositoryCount = function()
    {
        return array_length(__repositoryArray);
    }
    
    static GetRepositoryArray = function()
    {
        return __repositoryArray;
    }
    
    static GetRepositoryNameArray = function()
    {
        var _array = [];
        
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            array_push(_array,_repositoryArray[_i].GetName());
            ++_i;
        }
        
        return _array;
    }
    
    static GetHTTPSuccess = function()
    {
        return true;
    }
    
    static GetRefreshing = function()
    {
        return false;
    }
    
    static Refresh = function(_callback)
    {
        //Always redefinition of the callback
        __refreshCallback = _callback;
        
        //TODO
    }
    
    static Serialize = function()
    {
        return {
            name: __name,
            url:  __url,
            type: __type,
        };
    }
}
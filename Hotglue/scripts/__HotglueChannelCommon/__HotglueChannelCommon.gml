// Feather disable all

/// @param name
/// @param url

function __HotglueChannelCommon(_name, _url) constructor
{
    static __isFavorites = false;
    static __isRemote = true;
    
    __name = _name;
    __url  = _url;
    
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
    
    static Serialize = function()
    {
        var _array = [];
        
        var _repositoryArray = __repositoryArray;
        var _i = 0;
        repeat(array_length(_repositoryArray))
        {
            array_push(_array, _repositoryArray[_i].GetURL());
            ++_i;
        }
        
        return _array;
    }
    
    static Deserialize = function(_urlArray)
    {
        var _repositoryArray = __repositoryArray;
        array_resize(_repositoryArray, 0);
        
        var _i = 0;
        repeat(array_length(_urlArray))
        {
            AddRepository(_urlArray[_i]);
            ++_i;
        }
    }
    
    static AddRepository = function(_url, _forceType = undefined)
    {
        var _repository = GetRepositoryFromURL(_url);
        if (_repository == undefined)
        {
            _repository = HotglueEnsureRepository(_url, _forceType);
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
}
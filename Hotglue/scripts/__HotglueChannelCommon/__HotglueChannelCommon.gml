// Feather disable all

/// @param name
/// @param url

function __HotglueChannelCommon(_name, _url) constructor
{
    static _repoConstructor = __HotglueRepositoryLocal;
    
    __name = _name;
    __url  = _url;
    
    __repositoryArray = [];
    
    __refreshCallback = undefined;
    
    
    
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
    
    static AddRepository = function(_url)
    {
        array_push(__repositoryArray, new _repoConstructor(_url));
    }
    
    static GetRepositoryArray = function()
    {
        return __repositoryArray;
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
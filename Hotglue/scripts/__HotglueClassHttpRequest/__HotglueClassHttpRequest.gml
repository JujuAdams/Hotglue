// Feather disable all

/// @param url
/// @param [method=GET]
/// @param [allowBearerToken=true]

function __HotglueClassHttpRequest(_url, _method = "GET", _allowBearerToken = true) constructor
{
    static _system         = __HotglueSystem();
    static _httpRequestMap = _system.__httpRequestMap;
    
    __url    = _url;
    __method = _method;
    __body   = "";
    
    __callback = function(_success, _result) {};
    
    __headerStruct = {};
    __requestID = undefined;
    
    __result = undefined;
    
    //Detect if we need a GitHub bearer token
    if ((string_pos("github.com/", _url) > 0)
    ||  (string_pos("githubcontent.com/", _url) > 0))
    {
        if (_system.__githubUserAccessToken != undefined)
        {
            __headerStruct[$ "Bearer"] = _system.__githubUserAccessToken;
        }
    }
    
    
    
    static GetURL = function()
    {
        return __url;
    }
    
    static GetMethod = function()
    {
        return __method;
    }
    
    static GetHeaders = function()
    {
        return __headerString;
    }
    
    static GetBody = function()
    {
        return __body;
    }
    
    static SetBody = function(_string)
    {
        if (__requestID == undefined)
        {
            
        }
        else
        {
            __body = _string;
        }
        
        return self;
    }
    
    static SetHeaders = function(_struct)
    {
        if (__requestID == undefined)
        {
            
        }
        else
        {
            __headerStruct = _struct;
        }
        
        return self;
    }
    
    static AddHeader = function(_key, _value)
    {
        if (__requestID == undefined)
        {
            
        }
        else
        {
            __headerStruct[$ _key] = _value;
        }
        
        return self;
    }
    
    static Callback = function(_callback)
    {
        if (__result != undefined)
        {
            
        }
        else
        {
            __callback = _callback;
        }
        
        return self;
    }
    
    static Send = function()
    {
        if (__requestID != undefined)
        {
            
        }
        else
        {
            var _headerMap = json_decode(json_stringify(__headerStruct));
            
            __requestID = http_request(__url, __method, _headerMap, __body);
            _httpRequestMap[? __requestID] = self;
            
            ds_map_destroy(_headerMap);
        }
    }
}
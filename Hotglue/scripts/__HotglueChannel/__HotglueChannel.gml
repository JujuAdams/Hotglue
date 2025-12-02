// Feather disable all

/// @param url

function __HotglueChannel(_url) constructor
{
    __url = _url;
    
    __refreshCallback = undefined;
    
    __urlArray = [];
    __httpRequest = undefined;
    __httpSuccess = false;
    
    static GetURLArray = function()
    {
        return __urlArray;
    }
    
    static GetHTTPSuccess = function()
    {
        return __httpSuccess;
    }
    
    static GetRefreshing = function()
    {
        return (__httpRequest != undefined);
    }
    
    static Refresh = function(_callback)
    {
        //Always redefinition of the callback
        __refreshCallback = _callback;
        
        if (__httpRequest == undefined)
        {
            __HotglueTrace($"Refreshing channel \"{__url}\"");
            __httpRequest = new __HotglueClassHttpRequest(__url);
            
            __httpRequest.Callback(function(_httpRequest, _success, _result)
            {
                __httpRequest = undefined;
                
                if (not _success)
                {
                    __HotglueWarning($"\"{_httpRequest.GetURL()}\" HTTP request failed");
                }
                else
                {
                    try
                    {
                        var _json = json_parse(_result);
                    }
                    catch(_error)
                    {
                        show_debug_message(_error);
                        __HotglueWarning($"\"{_httpRequest.GetURL()}\" HTTP request was successful but failed to parse JSON");
                        _success = false;
                    }
                
                    if (_success)
                    {
                        _success = false;
                    
                        var _version = _json[$ "version"];
                        if (is_numeric(_version) && (_version == 0))
                        {
                            var _urlArray = _json[$ "links"];
                            if (not is_array(_urlArray))
                            {
                                __HotglueWarning($"\"{_httpRequest.GetURL()}\" Link array invalid");
                            }
                            else
                            {
                                __HotglueTrace($"Refreshed channel \"{__url}\". Found {array_length(_urlArray)} links");
                                
                                var _i = 0;
                                repeat(array_length(_urlArray))
                                {
                                    __HotglueTrace($"\"{_urlArray[_i]}\"");
                                    ++_i;
                                }
                                
                                _success = true;
                                
                                array_resize(__urlArray, 0);
                                array_copy(__urlArray, 0, _urlArray, 0, array_length(_urlArray));
                            }
                        }
                        else
                        {
                            __HotglueWarning($"\"{_httpRequest.GetURL()}\" JSON version \"{_version}\" unsupported");
                        }
                    }
                }
            
                __httpSuccess = _success;
                
                if (is_callable(__refreshCallback))
                {
                    __refreshCallback(self, _success);
                }
            });
            
            __httpRequest.Send();
        }
    }
    
    //static SetLinkArray = function(_inputArray)
    //{
    //    var _urlArray = __urlArray;
    //    array_resize(_urlArray, 0);
    //    
    //    var _i = 0;
    //    repeat(array_length(_inputArray))
    //    {
    //        var _inputURL = _inputArray[_i];
    //        
    //        var _name = _inputURL;
    //        if (string_char_at(_name, string_length(_name)) == "/")
    //        {
    //            _name = string_delete(_name, string_length(_name), 1);
    //        }
    //        
    //        var _substring = "github.com/";
    //        var _pos = string_pos(_substring, _name);
    //        
    //        _name = string_delete(_name, 1, _pos + string_length(_substring)-1);
    //        
    //        var _link = new ClassLink(_inputURL, _name);
    //        array_push(_urlArray, _link);
    //        
    //        ++_i;
    //    }
    //}
}
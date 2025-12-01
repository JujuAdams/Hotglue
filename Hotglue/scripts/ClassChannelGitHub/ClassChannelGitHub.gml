// Feather disable all

// https://api.github.com/repos/jujuadams/dotobj/pulls
// https://api.github.com/repos/JujuAdams/dotobj/pulls/12
// https://api.github.com/repos/cicadian/dotobj_merge/contents
// https://raw.githubusercontent.com/cicadian/dotobj_merge/master/README.md

function ClassChannelGitHub() : __ClassChannelCommon("GitHub") constructor
{
    __url = "";
    
    static GetURL = function()
    {
        return __url;
    }
    
    static SetURL = function(_url, _allowRefresh = true)
    {
        if (_url != __url)
        {
            __url = _url;
            
            if (_allowRefresh)
            {
                Refresh();
            }
        }
        
        return self;
    }
    
    static BuildHeader = function()
    {
        ImGuiText(__url);
        ImGuiSameLine();
        ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 20);
        if (ImGuiButton("Refresh"))
        {
            Refresh();
        }
    }
    
    static BuildRightPanel = function()
    {
        if (not __selectedLink.GetMetadataExists())
        {
            ImGuiTextColored("\"Hotglue Metadata\" Note asset not found.", INTERFACE_COLOR_RED_TEXT);
            ImGuiNewLine();
        }
            
        __selectedLink.BuildForView();
        
        ImGuiNewLine();
        if (ImGuiButton("Refresh"))
        {
            
        }
    }
    
    static Refresh = function()
    {
        InterfaceStatus($"Refreshing channel \"{__url}\"");
        array_resize(__linkArray, 0);
        
        new HttpRequest(__url)
        .Callback(function(_httpRequest, _success, _result)
        {
            if (not _success)
            {
                InterfaceWarning($"\"{_httpRequest.GetURL()}\" HTTP request failed");
                return;
            }
            
            try
            {
                var _json = json_parse(_result);
            }
            catch(_error)
            {
                InterfaceWarning($"\"{_httpRequest.GetURL()}\" HTTP request was successful but failed to parse JSON");
                return;
            }
            
            var _version = _json[$ "version"];
            if (is_numeric(_version) && (_version == 0))
            {
                var _linkArray = _json[$ "links"];
                if (not is_array(_linkArray))
                {
                    InterfaceWarning($"\"{_httpRequest.GetURL()}\" Link array invalid");
                    return;
                }
        
                SetLinkArray(_linkArray);
                InterfaceStatus($"Refreshed channel \"{__url}\". Found {array_length(__linkArray)} links");
            }
            else
            {
                InterfaceWarning($"\"{_httpRequest.GetURL()}\" Version \"{_version}\" unsupported");
                return;
            }
        })
        .Send();
    }
    
    static SetLinkArray = function(_inputArray)
    {
        var _linkArray = __linkArray;
        array_resize(_linkArray, 0);
        
        var _i = 0;
        repeat(array_length(_inputArray))
        {
            var _inputURL = _inputArray[_i];
            
            var _name = _inputURL;
            if (string_char_at(_name, string_length(_name)) == "/")
            {
                _name = string_delete(_name, string_length(_name), 1);
            }
            
            var _substring = "github.com/";
            var _pos = string_pos(_substring, _name);
            
            _name = string_delete(_name, 1, _pos + string_length(_substring)-1);
            
            var _link = new ClassLink(_inputURL, _name);
            array_push(_linkArray, _link);
            
            ++_i;
        }
        
        if (__selectedLink != undefined)
        {
            var _selectedURL = __selectedLink.GetURL();
            __selectedLink = undefined;
            
            var _i = 0;
            repeat(array_length(_linkArray))
            {
                if (_linkArray[_i].GetURL() == _selectedURL)
                {
                    __selectedLink = _linkArray[_i];
                    break;
                }
                
                ++_i;
            }
        }
    }
}
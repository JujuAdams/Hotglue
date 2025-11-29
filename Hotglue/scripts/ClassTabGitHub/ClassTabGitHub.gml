// Feather disable all

function ClassTabGitHub() : ClassTab() constructor
{
    __channelURL = "https://raw.githubusercontent.com/JujuAdams/Hotglue-Index/refs/heads/main/github.json";
    
    __linkArray = [];
    __selectedLink = undefined;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("GitHub"))
        {
            Build();
            ImGuiEndTabItem();
        }
    }
    
    static Build = function()
    {
        ImGuiText(__channelURL);
        ImGuiSameLine();
        ImGuiSetCursorPosX(ImGuiGetCursorPosX() + 20);
        if (ImGuiButton("Refresh"))
        {
            Refresh();
        }
        
        ImGuiBeginChild("leftPane", 250, undefined, ImGuiChildFlags.Border);
        
        var _linkArray = __linkArray;
        if (array_length(_linkArray) <= 0)
        {
            ImGuiTextWrapped("No links found.\n\nPlease refresh this channel and check for warnings.");
        }
        else
        {
            var _i = 0;
            repeat(array_length(_linkArray))
            {
                if (ImGuiSelectable(_linkArray[_i].name))
                {
                    __selectedLink = _linkArray[_i];
                }
                
                ++_i;
            }
        }
        
        ImGuiEndChild();
        
        ImGuiSameLine();
        ImGuiBeginChild("rightPane", undefined, undefined, ImGuiChildFlags.Border);
        
        if (__selectedLink == undefined)
        {
            ImGuiText("Please select a link from the left-hand side.");
        }
        else
        {
            ImGuiTextWrapped(__selectedLink.url);
            ImGuiNewLine();
            ImGuiTextWrapped(__selectedLink.name);
        }
        
        ImGuiEndChild();
    }
    
    static Refresh = function()
    {
        new HttpRequest(__channelURL)
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
            
            array_push(_linkArray, {
                url:  _inputURL,
                name: _name,
            });
            
            ++_i;
        }
        
        if (__selectedLink != undefined)
        {
            var _selectedURL = __selectedLink.link;
            __selectedLink = undefined;
            
            var _i = 0;
            repeat(array_length(_linkArray))
            {
                if (_linkArray[_i].url == _selectedURL)
                {
                    __selectedLink = _linkArray[_i];
                    break;
                }
                
                ++_i;
            }
        }
    }
}
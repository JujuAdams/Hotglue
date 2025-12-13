// Feather disable all

/// @param text
/// @param [url=text]

function InterfaceLinkText(_text, _url = _text)
{
    var _isRemote = InterfaceGuessURLIsRemote(_url);
    
    if (HotglueGetExecuteShellAvailable() || _isRemote)
    {
        ImGuiTextLink(_text);
        
        var _clicked = ImGuiIsItemClicked();
        if (ImGuiBeginItemTooltip())
        {
            ImGuiText($"Open \"{_isRemote? _url : filename_dir(_url)}\"");
            ImGuiEndTooltip();
        }
            
        if (_clicked)
        {
            InterfaceOpenURL(_url);
        }
    }
    else
    {
        ImGuiText(_text);
    }
}
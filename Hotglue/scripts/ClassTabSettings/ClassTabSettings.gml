// Feather disable all

function ClassTabSettings() : ClassTab() constructor
{
    __advanced = false;
    
    static TabItem = function()
    {
        if (ImGuiBeginTabItem("Settings"))
        {
            ImGuiBeginChild("channelSelector", undefined, 200, ImGuiChildFlags.Border);
            var _channelArray = oInterface.channelArray;
            var _i = 0;
            repeat(array_length(_channelArray))
            {
                var _channel = _channelArray[_i];
                ImGuiSelectable(_channel.GetURL());
                ++_i;
            }
            ImGuiEndChild();
            
            ImGuiNewLine();
            
            __advanced = ImGuiCheckbox("I know what I'm doing", __advanced);
            if (__advanced)
            {
                ImGuiIndent();
                ImGuiTextColored("Here be dragons.", INTERFACE_COLOR_RED_TEXT);
                HotglueSetSuppressGitAssert(ImGuiCheckbox("Suppress .git directory assert", HotglueGetSuppressGitAssert()));
                HotglueSetDestructiveCopy(ImGuiCheckbox("Resource copy is destructive", HotglueGetDestructiveCopy()));
                ImGuiUnindent();
            }
            
            ImGuiEndTabItem();
        }
    }
}
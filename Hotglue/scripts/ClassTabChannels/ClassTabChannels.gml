// Feather disable all

function ClassTabChannels() : ClassTab() constructor
{
    static __name = "Explore Channels";
    
    __openChannel = undefined;
    
    static MenuItem = function()
    {
        if (ImGuiBeginMenu(__name))
        {
            var _i = 0;
            repeat(HotglueGetChannelCount())
            {
                var _channel = HotglueGetChannelByIndex(_i);
                if (ImGuiMenuItem($"{_channel.GetName()}###channel{_i}"))
                {
                    __openChannel = _channel;
                    other.menuFocus = self;
                    other.logOpen = false;
                }
                
                ++_i;
            }
            
            ImGuiEndMenu();
        }
    }
    
    static Build = function()
    {
        if (__openChannel == undefined)
        {
            var _i = 0;
            repeat(HotglueGetChannelCount())
            {
                var _channel = HotglueGetChannelByIndex(_i);
                
                if (ImGuiButton($"{_channel.GetName()}###channel{_i}"))
                {
                    __openChannel = _channel;
                }
                
                ++_i;
            }
        }
        else
        {
            InterfaceEnsureChannelView(__openChannel).BuildForExplore();
        }
    }
}
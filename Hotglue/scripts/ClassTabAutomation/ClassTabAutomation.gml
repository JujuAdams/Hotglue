// Feather disable all

function ClassTabAutomation() : ClassTab() constructor
{
    static __name = "Automation";
    
    try
    {
        var _buffer = buffer_load("hotglue_reference.txt");
        __referenceString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        __referenceString = string_replace_all(__referenceString, "\t", "    ");
        
        LogTrace("Hotglue reference loaded");
    }
    catch(_error)
    {
        LogWarning("\"hotglue_reference.txt\" failed to load");
        __referenceString = "Hotglue reference failed to load.";
    }
    
    __content = "//Type GML here!";
    __showReference = true;
    
    __gmlcEnvironment = new GMLC_Env();
    __gmlcEnvironment.expose_user_functions();
    
    static MenuItem = function()
    {
        if (ImGuiMenuItem(__name))
        {
            other.menuFocus = self;
            other.logOpen = false;
        }
    }
    
    static Build = function()
    {
        if (ImGuiButton("Execute") || keyboard_check_pressed(vk_f5))
        {
            try
            {
                var _program = __gmlcEnvironment.compile(__content);
                _program();
                
                LogTraceAndStatus("Program executed successfully");
            }
            catch(_error)
            {
                LogWarning(_error);
                LogWarning("Program encountered an error");
            }
        }
        
        ImGuiSameLine(undefined, 20);
        
        if (ImGuiButton("Load from file...") || (keyboard_check(vk_control) && keyboard_check_pressed(ord("O"))))
        {
            var _path = get_open_filename("*.*", "");
            if (_path != "")
            {
                var _buffer = buffer_load(_path);
                __content = buffer_read(_buffer, buffer_text);
                buffer_delete(_buffer);
            }
        }
        
        ImGuiSameLine(undefined, 20);
        
        if (ImGuiButton("Save to file...") || (keyboard_check(vk_control) && keyboard_check_pressed(ord("S"))))
        {
            var _path = get_save_filename("*.*", "");
            if (_path != "")
            {
                var _buffer = buffer_create(string_byte_length(__content), buffer_fixed, 1);
                buffer_write(_buffer, buffer_text, __content);
                buffer_save(_buffer, _path);
                buffer_delete(_buffer);
            }
        }
        
        ImGuiSameLine(undefined, 20);
        
        if (ImGuiButton(__showReference? "Hide reference" : "Show reference"))
        {
            __showReference = not __showReference;
        }
        
        if (__showReference)
        {
            ImGuiColumns(2);
            BuildInput();
            ImGuiNextColumn();
            ImGuiText(__referenceString);
        }
        else
        {
            BuildInput();
        }
    }
    
    static BuildInput = function()
    {
        __content = ImGuiInputTextMultiline("##textInput", __content, ImGuiGetContentRegionAvailX(), ImGuiGetContentRegionAvailY(), ImGuiInputTextFlags.AllowTabInput);
    }
}
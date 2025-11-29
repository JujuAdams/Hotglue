ImGuiSetNextWindowSize(window_get_width()/2, window_get_height()/2, ImGuiCond.Once);
var ret = ImGuiBegin("ImGM Example", true, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
ImGuiEnd();
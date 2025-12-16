// Feather disable all

/// @param path
/// @param [test=true]

function HotglueSetProjectToolPath(_path, _test = true)
{
    static _system = __HotglueSystem();
    
    if (_path != _system.__projectToolPath)
    {
        if (_test)
        {
            if (not HotglueProjectToolTest(_path))
            {
                __HotglueTrace($"Failed to set ProjectTool path to \"{_path}\", test unsuccessful");
                return false;
            }
            else
            {
                _system.__projectToolPath = _path;
                __HotglueTrace($"Set ProjectTool path to \"{_path}\"");
            }
        }
        else
        {
            _system.__projectToolPath = _path;
            __HotglueTrace($"Set ProjectTool path to \"{_path}\" (no test)");
        }
    }
    
    return true;
}
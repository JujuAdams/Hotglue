// Feather disable all

/// @param path

function HotglueSetCachePath(_path)
{
    static _system = __HotglueSystem();
    
    _path = string_replace_all(_path, "\\", "/");
    
    if (string_char_at(_path, string_length(_path)) != "/")
    {
        _path += "/";
    }
    
    if (_path != _system.__cachePath)
    {
        directory_destroy(_system.__cachePath);
        
        __HotglueTrace($"Set cache path to \"{_path}\"");
        _system.__cachePath = _path;
        
        directory_create(_path);
    }
}
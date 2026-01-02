// Feather disable all

/// @param path
/// @param string

function __HTTPCacheSaveString(_path, _string)
{
    static _buffer = buffer_create(1024, buffer_grow, 1);
    
    if (HTTP_CACHE_DISK_AVAILABLE)
    {
        buffer_seek(_buffer, buffer_seek_start, 0);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save_ext(_buffer, _path, 0, buffer_tell(_buffer));
    }
}
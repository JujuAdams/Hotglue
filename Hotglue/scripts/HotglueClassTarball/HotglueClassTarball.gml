/// @param buffer

function HotglueClassTarball(_buffer) constructor
{
    __data = _buffer;
    
    __Initialize();
    
    try
    {
        while(((buffer_tell(_buffer) + 4) < buffer_get_size(_buffer)) && (buffer_peek(_buffer, buffer_tell(_buffer), buffer_u32) != 0))
        {
            var _entry = new __TarballEntry();
            _entry.__ReadFromBuffer(_buffer);
            array_push(__entries, _entry);
            
            //512-byte aligned
            var _remaining = 512 - (buffer_tell(_buffer) mod 512);
            if ((_remaining > 0) && (_remaining < 512))
            {
                buffer_seek(_buffer, buffer_seek_relative, _remaining);
            }
        }
    }
    catch(_error)
    {
        show_debug_message(_error);
        __Initialize();
    }
    
    
    
    
    
    static __Initialize = function()
    {
        __entries = [];
    }
    
    static Destroy = function()
    {
        __Initialize();
        buffer_delete(__data);
    }
    
    static Decompress = function(_destDirectory)
    {
        var _i = 0;
        repeat(array_length(__entries))
        {
            __entries[_i].__Decompress(__data, _destDirectory);
            ++_i;
        }
    }
}

function __TarballEntry() constructor
{
    //read regular headers
    __filename     = undefined;
    __mode         = undefined;
    __uid          = undefined;
    __gid          = undefined;
    __size         = undefined;
    __modifiedTime = undefined;
    __checksum     = undefined;
    __type         = undefined;
    __linkName     = undefined;
    __ustar        = undefined;
    __version      = undefined;
    __uname        = undefined;
    __gname        = undefined;
    __devmajor     = undefined;
    __devminor     = undefined;
    __namePrefix   = undefined;
    
    
    
    
    
    static __ReadFromBuffer = function(_buffer)
    {
        __filename     = __ReadString(_buffer, 100);
        __mode         = __ReadString(_buffer, 8);
        __uid          = __ReadString(_buffer, 8);
        __gid          = __ReadString(_buffer, 8);
        __size         = __ReadInteger(_buffer, 12);
        __modifiedTime = HotglueTimeUnixToGameMaker(__ReadInteger(_buffer, 12));
        __checksum     = __ReadString(_buffer, 8);
        __type         = __ReadString(_buffer, 1);
        __linkName     = __ReadString(_buffer, 100);
        __ustar        = __ReadString(_buffer, 6);
        
        //User headers
        if (__ustar == "ustar")
        {
            __version    = __ReadString(_buffer, 2);
            __uname      = __ReadString(_buffer, 32);
            __gname      = __ReadString(_buffer, 32);
            __devmajor   = __ReadString(_buffer, 8);
            __devminor   = __ReadString(_buffer, 8);
            __namePrefix = __ReadString(_buffer, 155);
        
            if (__namePrefix != "")
            {
                __filename = __namePrefix + __filename;
            }
        
            buffer_seek(_buffer, buffer_seek_relative, 12);
        }
        else
        {
            buffer_seek(_buffer, buffer_seek_relative, 249);
        }
        
        __dataOffset = buffer_tell(_buffer);
        buffer_seek(_buffer, buffer_seek_relative, __size);
    }
    
    static __ReadString = function(_buffer, _byteCount)
    {
        static _workBuffer = buffer_create(128, buffer_grow, 1);
        
        if (_byteCount+1 > buffer_get_size(_buffer))
        {
            buffer_resize(_buffer, _byteCount+1);
        }
        
        buffer_copy(_buffer, buffer_tell(_buffer), _byteCount, _workBuffer, 0);
        buffer_seek(_buffer, buffer_seek_relative, _byteCount);
        
        buffer_poke(_workBuffer, _byteCount, buffer_u8, 0x00);
        
        var _string = buffer_peek(_workBuffer, 0, buffer_string);
        
        return _string;
    }
    
    static __ReadInteger = function(_buffer, _byteCount)
    {
        var _end = buffer_tell(_buffer) + _byteCount;
        
        var _decimal = 0;
        repeat(_byteCount)
        {
            var _byte = buffer_read(_buffer, buffer_u8);
            if ((_byte == 0) || (_byte == 0x20))
            {
                break;
            }
            else
            {
                _decimal = (_decimal << 3) | (_byte - 0x30);
            }
        }
        
        buffer_seek(_buffer, buffer_seek_start, _end);
        return _decimal;
    }
    
    static __Decompress = function(_data, _destDirectory)
    {
        static _emptyBuffer = buffer_create(0, buffer_fixed, 1);
        
        _destDirectory += "/";
        
        if ((__type == "0") || (__type == "1"))
        {
            var _directory = _destDirectory + filename_path(__filename);
            directory_create(_directory);
            
            if (__size == 0)
            {
                buffer_save(_emptyBuffer, _destDirectory + __filename);
            }
            else
            {
                buffer_save_ext(_data, _destDirectory + __filename, __dataOffset, __size);
            }
        }
    }
}
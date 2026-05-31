/// @param buffer

function HotglueClassZip(_buffer) constructor
{
    __data = _buffer;
    
    __Initialize();
    
    try
    {
        __centralDirectoryStart = undefined;
        __centralDirectoryEnd   = undefined;
        
        var _pos = buffer_get_size(_buffer) - 22;
        repeat(_pos+1)
        {
            if (buffer_peek(_buffer, _pos, buffer_u32) == 0x06054b50)
            {
                var _startPos = buffer_peek(_buffer, _pos + 16, buffer_u32);
                if (buffer_peek(_buffer, _startPos, buffer_u32) == 0x02014b50)
                {
                    __centralDirectoryStart = _startPos;
                    __centralDirectoryEnd   = _pos;
                }
            }
            
            --_pos;
        }
        
        if (__centralDirectoryStart == undefined)
        {
            throw "Central directory not found";
        }
        
        __totalEntries = buffer_peek(_buffer, __centralDirectoryEnd + 10, buffer_u16);
        
        buffer_seek(_buffer, buffer_seek_start, __centralDirectoryStart);
        repeat(__totalEntries)
        {
            if (buffer_read(_buffer, buffer_u32) != 0x02014b50)
            {
                throw "Unexpected end of central directory";
            }
            
            var _entry = new __ZipEntry();
            _entry.__ReadFromBuffer(_buffer);
            array_push(__entries, _entry);
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
        
        __centralDirectoryStart = undefined;
        __centralDirectoryEnd   = undefined;
    }
    
    static Destroy = function()
    {
        __Initialize();
        buffer_delete(__data);
    }
    
    static Decompress = function(_destDirectory)
    {
        buffer_save(__data, "temp.zip");
        zip_unzip("temp.zip", _destDirectory);
        file_delete("temp.zip");
    }
}

function __ZipEntry() constructor
{
    static __ReadFromBuffer = function(_buffer)
    {
        __centralDirOffset = buffer_tell(_buffer) - 32;
        
        var _version = buffer_read(_buffer, buffer_u16);
        __version = _version & 0xFF;
        __os      = _version >> 8;
        
        __versionRequired = buffer_read(_buffer, buffer_u16);
        
        buffer_seek(_buffer, buffer_seek_relative, 2); //Skip "general flags"
        
        __compressionMethod = buffer_read(_buffer, buffer_u16);
        
        var _dosTime = buffer_read(_buffer, buffer_u16);
        var _dosDate = buffer_read(_buffer, buffer_u16);
        __modifiedTime = HotglueTimeDOSToGameMaker(_dosDate, _dosTime);
        
        __crc              = buffer_read(_buffer, buffer_u32);
        __compressedSize   = buffer_read(_buffer, buffer_u32);
        __uncompressedSize = buffer_read(_buffer, buffer_u32);
        
        var _filenameLength = buffer_read(_buffer, buffer_u16);
        var _extraLength    = buffer_read(_buffer, buffer_u16);
        var _commentLength  = buffer_read(_buffer, buffer_u16);
        
        buffer_seek(_buffer, buffer_seek_relative, 4); //Skip "disk start" and "file attributes" (2 bytes each)
        
        __externalAttributes = buffer_read(_buffer, buffer_u32);
        __headerOffset       = buffer_read(_buffer, buffer_u32);
        
        if (_filenameLength > 0)
        {
            __filename = __ReadString(_buffer, _filenameLength);
        }
        
        buffer_seek(_buffer, buffer_seek_relative, _extraLength); //Skip extra data
        
        if (_commentLength > 0)
        {
            __comment = __ReadString(_buffer, _commentLength);
        }
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
}
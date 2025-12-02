// Feather disable all

function HotglueClearUnzipCache()
{
    __HotglueTrace($"Clearing unzip cache at \"{HOTGLUE_UNZIP_CACHE_DIRECTORY}\"");
    directory_destroy(HOTGLUE_UNZIP_CACHE_DIRECTORY);
}
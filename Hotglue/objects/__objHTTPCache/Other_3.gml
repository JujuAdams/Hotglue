// Feather disable all

if (HTTP_CACHE_CLEAR_ON_EXIT)
{
    HTTPCacheClear();
}
else
{
    HTTPCachePrune();
}
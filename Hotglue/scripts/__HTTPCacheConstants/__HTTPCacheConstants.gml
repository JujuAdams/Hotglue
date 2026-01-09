// Feather disable all

////////////////////////////////////////////////////////////////////////////
//                                                                        //
// You're welcome to use any of the following macros in your game but ... //
//                                                                        //
//                       DO NOT EDIT THIS SCRIPT                          //
//                       Bad things might happen.                         //
//                                                                        //
// Customisation options can be found in the `__HttpCacheConfig` scripts. //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

#macro HTTP_CACHE_VERSION  "1.2.0.1"
#macro HTTP_CACHE_DATE     "2026-01-09"

/// Whether caching of data in local storage is permitted.
#macro HTTP_CACHE_DISK_AVAILABLE  (HTTP_CACHE_USE_DISK && ((os_type == os_windows) || (os_type == os_macosx) || (os_type == os_linux) || (os_type == os_android) || (os_type == os_ios) || (os_type == os_tvos)))
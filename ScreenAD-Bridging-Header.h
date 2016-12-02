//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const NSUInteger ddLogLevel = DDLogLevelDebug;
static const BOOL       debugMode  = TRUE;
#else
static const NSUInteger ddLogLevel = DDLogLevelError;
static const BOOL       debugMode  = FALSE;
#endif

#import <Foundation/Foundation.h>

void _plog(const char *file, int lineNumber, const char *funcName, id who,
           NSString *format, ...);

#define plogDebug(args...) [logger logWithLevel:PL_DEBUG method:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ caller:self body:args]
#define plogInfo(args...) [logger logWithLevel:PL_INFO method:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ caller:self body:args]
#define plogWarn(args...) [logger logWithLevel:PL_WARN method:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ caller:self body:args]
#define plogError(args...) [logger logWithLevel:PL_ERROR method:__PRETTY_FUNCTION__ file:__FILE__ line:__LINE__ caller:self body:args]

#import <Foundation/Foundation.h>
#import "plog.h"

enum PLogLevelEnum {
    PL_DEBUG = 0, PL_INFO, PL_WARN, PL_ERROR, PL_FATAL, PL_NONE
};

typedef enum PLogLevelEnum PLogLevel;

@protocol PLoggerAppender;

@interface PLogger : NSObject { }

@property (weak, nonatomic, readonly) NSString *name;
@property (nonatomic, assign) PLogLevel logLevel;

+ (PLogger *)getLogger:(NSString *)name;

- (id)initWithName:(NSString *)name;
- (void)addAppender:(id<PLoggerAppender>)appender;

- (void)logWithLevel:(PLogLevel)level
              method:(const char *)method
                file:(const char *)file
                line:(int)lineNumber
              caller:(__unsafe_unretained id)who
                body:(NSString *)format, ...;
- (void)flush;
@end

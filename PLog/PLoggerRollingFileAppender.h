#import <Foundation/Foundation.h>

#import "PLoggerAppender.h"
#import "PLoggerFormatter.h"
#import "PLogger.h"

@interface PLoggerRollingFileAppender : NSObject
<PLoggerAppender> { }

@property (nonatomic, assign) PLogLevel logLevel;
@property (nonatomic, strong) id<PLoggerFormatter> formatter;

- (void)rollover;
+ (NSString *)logFilesDir;
@end

#import <Foundation/Foundation.h>

#import "PLoggerAppender.h"
#import "PLoggerFormatter.h"
#import "PLogger.h"

@interface PLoggerDefaultAppender : NSObject
<PLoggerAppender> { }

@property (nonatomic, assign) PLogLevel logLevel;

- (void)setFormatter:(id<PLoggerFormatter>)formatter;
@end

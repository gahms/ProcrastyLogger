#import "PLoggerDefaultAppender.h"
#import "PLoggerFormatter.h"

@interface PLoggerDefaultAppender ()
@property (nonatomic, strong) id<PLoggerFormatter> logFormatter;
@end

@implementation PLoggerDefaultAppender
@synthesize logFormatter = _logFormatter;
@synthesize logLevel = _logLevel;


- (void)setFormatter:(id<PLoggerFormatter>)formatter
{
    self.logFormatter = formatter;
}

- (void)append:(PLoggerLine *)logLine
{
    if(logLine.logLevel < _logLevel) {
        return;
    }
    NSString * formatted = [_logFormatter format:logLine];
    fprintf(stderr, "%s", [formatted UTF8String]);
}

- (void)flush
{
    fflush(stderr);
}

@end

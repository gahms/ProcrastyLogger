#import "PLogger.h"
#import "PLoggerStore.h"
#import "PLoggerLine.h"
#import "PLoggerAppender.h"

@interface PLogger ()
@property (nonatomic, strong) NSMutableArray * appenders;
@end

@implementation PLogger

+ (PLogger *)getLogger:(NSString *)name
{
    //NSString * className = NSStringFromClass(aClass);
    return [[PLoggerStore getInstance] getLoggerWithName:name];
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if(self) {
        _name = name;
        _logLevel = PL_DEBUG;
        _appenders = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addAppender:(id<PLoggerAppender>)appender
{
    [_appenders addObject:appender];
}

- (void)logWithLevel:(PLogLevel)level
              method:(const char *)method
                file:(const char *)file
                line:(int)lineNumber
              caller:(__unsafe_unretained id)who
                body:(NSString *)format, ...
{
    if(level < _logLevel) {
        return;
    }
    va_list ap;

    va_start(ap, format);
	NSString *body =  [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);

    PLoggerLine * logLine = [[PLoggerLine alloc] init];
    logLine.thread = [NSThread currentThread];
    logLine.timestamp = [NSDate date];
    logLine.logLevel = level;
    logLine.who = who;
    logLine.method = method;
    logLine.file = file;
    logLine.lineNumber = lineNumber;
    logLine.message = body;
    for(id<PLoggerAppender> appender in _appenders) {
        [appender append:logLine];
    }
}

- (void)flush
{
    for(id<PLoggerAppender> appender in _appenders) {
        [appender flush];
    }
}
@end

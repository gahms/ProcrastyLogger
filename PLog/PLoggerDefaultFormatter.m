#import "PLoggerDefaultFormatter.h"

@interface PLoggerDefaultFormatter ()
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@end

@implementation PLoggerDefaultFormatter
@synthesize dateFormatter = _dateFormatter;

static char * levelStrings[] = { "DEBUG", "INFO ", "WARN ", "ERROR", "FATAL" };

- (id)init
{
    self = [super init];
    if(self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //[df setDateStyle:NSDateFormatterNoStyle];
        //[df setTimeStyle:NSDateFormatterLongStyle];
        [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    }
    return self;
}


- (NSString *)format:(PLoggerLine *)logLine
{
    //NSString *threadName = [[NSThread currentThread] name];
    //NSString *fileName = [[NSString stringWithUTF8String:logLine.file] lastPathComponent];

    NSString *ts = [_dateFormatter stringFromDate:logLine.timestamp];
    return [NSString stringWithFormat:@"%@ %s 0x%x %s"
            //" %@(%d)"
            " %@\n",
            ts, levelStrings[logLine.logLevel],
            (unsigned int)logLine.who,
            logLine.method,
            //fileName, logLine.lineNumber,
            logLine.message];

}
@end

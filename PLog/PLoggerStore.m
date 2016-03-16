#import "plog.h"
#import "PLoggerStore.h"

@interface PLoggerStore ()
@property (nonatomic, strong) NSMutableDictionary * loggersByName;
@end

static PLoggerStore * instance = nil;

@implementation PLoggerStore
@synthesize loggersByName = _loggersByName;

+ (PLoggerStore *)getInstance
{
    if(instance == nil) {
        instance = [[PLoggerStore alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if(self) {
        _loggersByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)reset
{
    _loggersByName = [[NSMutableDictionary alloc] init];
}

- (void)flush
{
    for (PLogger * l in [_loggersByName allValues]) {
        [l flush];
    }
}

- (PLogger *)getLoggerWithName:(NSString *)loggerName
{
    PLogger * logger = [_loggersByName objectForKey:loggerName];
    if(logger == nil) {
        logger = [_loggersByName objectForKey:@"*"];
    }
    return logger;
}

- (NSArray *)getLoggers
{
    return [_loggersByName allValues];
}

- (void)storeLogger:(PLogger *)logger
{
    if(logger != nil) {
        //plog(@"logger: name = %@, level = %d", logger.name, logger.logLevel);
        [_loggersByName setObject:logger forKey:logger.name];
    }
}

@end

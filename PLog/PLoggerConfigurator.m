#import "PLoggerConfigurator.h"
#import "PLogger.h"
#import "PLoggerStore.h"
#import "PLoggerDefaultAppender.h"
#import "PLoggerDefaultFormatter.h"
#import "PLoggerRollingFileAppender.h"


@interface PLoggerConfigurator()
{
    id<PLoggerAppender> _consoleAppender;
    id<PLoggerAppender> _fileApender;
}
@end

@implementation PLoggerConfigurator

- (PLogLevel)logLevelFromChar:(NSString *)levelChar
{
    if([levelChar isEqualToString:@"D"]) {
        return PL_DEBUG;
    } else if([levelChar isEqualToString:@"I"]) {
        return PL_INFO;
    } else if([levelChar isEqualToString:@"W"]) {
        return PL_WARN;
    } else if([levelChar isEqualToString:@"E"]) {
        return PL_ERROR;
    } else if([levelChar isEqualToString:@"F"]) {
        return PL_FATAL;
    } else {
        return PL_INFO;
    }
}

- (NSString *)charFromLogLevel:(PLogLevel)logLevel
{
    if(logLevel == PL_DEBUG) {
        return @"D";
    } else if(logLevel == PL_INFO) {
        return @"I";
    } else if(logLevel == PL_WARN) {
        return @"W";
    } else if(logLevel == PL_ERROR) {
        return @"E";
    } else if(logLevel == PL_FATAL) {
        return @"F";
    } else {
        return @"I";
    }
}

/*
 http://stackoverflow.com/questions/3184235/how-to-redirect-the-nslog-output-to-file-instead-of-console

- (void) redirectConsoleLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

 also: check if we have a console or not
 if (!isatty(STDERR_FILENO)) {
 // Redirection code
 }

 also: write to /dev/console instead so we can still redirect stderr ?
 */

- (void)reset
{
    _consoleAppender = nil;
    _fileApender = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggers"];
    [[PLoggerStore getInstance] reset];
}

- (void)enableAllConsoleWithLevel:(PLogLevel)logLevel
{
    PLogger * logger = [[PLogger alloc] initWithName:@"*"];
    logger.logLevel = logLevel;

    PLoggerDefaultFormatter * df = [[PLoggerDefaultFormatter alloc] init];
    PLoggerDefaultAppender * da = [[PLoggerDefaultAppender alloc] init];
    _consoleAppender = da;
    [da setFormatter:df];
    [da setLogLevel:PL_DEBUG];
    [logger addAppender:da];

    PLoggerRollingFileAppender * fa = [[PLoggerRollingFileAppender alloc] init];
    _fileApender = fa;
    [fa setFormatter:df];
    [fa setLogLevel:PL_DEBUG];
    [logger addAppender:fa];

    [[PLoggerStore getInstance] storeLogger:logger];
}

- (void)enableAllWithLevel:(PLogLevel)logLevel
{
    if(logLevel == PL_NONE) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggers"];
    } else {
        NSArray * loggers = [NSArray arrayWithObject:
                             [NSString stringWithFormat:@"%@*",
                              [self charFromLogLevel:logLevel]]];

        [[NSUserDefaults standardUserDefaults] setObject:loggers forKey:@"loggers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self configure];
}

- (void)setLogger:(NSString *)loggerName toLevel:(PLogLevel)logLevel
{
    PLogger * logger = [[PLogger alloc] initWithName:loggerName];
    logger.logLevel = logLevel;

    [logger addAppender:_consoleAppender];
    [logger addAppender:_fileApender];

    [[PLoggerStore getInstance] storeLogger:logger];
}

- (void)configure
{
    // TODO: Reset all loggers

    NSArray * loggers
    = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggers"];
    if(loggers == nil) {
        return;
    }

    PLoggerDefaultFormatter * df = [[PLoggerDefaultFormatter alloc] init];

    //PLoggerDefaultAppender * da = [[PLoggerDefaultAppender alloc] init];
    PLoggerRollingFileAppender * da = [[PLoggerRollingFileAppender alloc] init];
    _fileApender = da;

    [da setFormatter:df];
    [da setLogLevel:PL_DEBUG];

    for(NSString * loggerCfg in loggers) {
        NSString * levelChar = [loggerCfg substringToIndex:1];
        NSString * loggerName = [loggerCfg substringFromIndex:1];
        PLogLevel logLevel = [self logLevelFromChar:levelChar];
        PLogger * logger = [[PLogger alloc] initWithName:loggerName];
        logger.logLevel = logLevel;
        [logger addAppender:da];
        [[PLoggerStore getInstance] storeLogger:logger];
    }
}

- (void)handleUrl:(NSURL *)url
{
    NSString * loggerCfg = [url host];
    NSArray * loggers = [loggerCfg componentsSeparatedByString:@","];

    [[NSUserDefaults standardUserDefaults] setObject:loggers forKey:@"loggers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getConfigString
{
    NSMutableString * configString = [[NSMutableString alloc] init];
    NSArray * loggers = [[PLoggerStore getInstance] getLoggers];
    for(PLogger * logger in loggers) {
        if([configString length] > 0) {
            [configString appendString:@","];
        }
        [configString appendFormat:@"%@%@",
         [self charFromLogLevel:logger.logLevel],
         logger.name];
    }

    return configString;
}
@end

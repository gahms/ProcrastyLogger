#import <Foundation/Foundation.h>

#import "PLogger.h"

@interface PLoggerConfigurator : NSObject

- (void)reset;
- (void)configure;
- (void)enableAllConsoleWithLevel:(PLogLevel)logLevel;
- (void)enableAllWithLevel:(PLogLevel)logLevel;
- (void)setLogger:(NSString *)loggerName toLevel:(PLogLevel)logLevel;
- (void)handleUrl:(NSURL *)url;
- (NSString *)getConfigString;
@end

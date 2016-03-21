#import <Foundation/Foundation.h>

#import "PLogger.h"

@interface PLoggerStore : NSObject { }

+ (PLoggerStore *)getInstance;
- (void)reset;
- (PLogger *)getLoggerWithName:(NSString *)loggerName;
- (NSArray *)getLoggers;
- (void)storeLogger:(PLogger *)logger;
- (void)flush;
@end

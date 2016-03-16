#import <Foundation/Foundation.h>

#import "PLoggerLine.h"

@protocol PLoggerFormatter <NSObject>
- (NSString *)format:(PLoggerLine *)logLine;
@end

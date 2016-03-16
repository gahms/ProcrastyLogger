#import <Foundation/Foundation.h>

#import "PLoggerLine.h"

@protocol PLoggerAppender <NSObject>
- (void)append:(PLoggerLine *)logLine;
- (void)flush;
@end

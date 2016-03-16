#import <Foundation/Foundation.h>

@interface PLoggerZipHandler : NSObject

+ (NSString *)logFilesGlob;
- (NSString *)makeLogsZip;
- (void)uploadLogsFrom:(UIView *)presentingView;
@end

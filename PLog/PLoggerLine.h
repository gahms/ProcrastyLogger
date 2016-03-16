#import <Foundation/Foundation.h>

#import "PLogger.h"

@interface PLoggerLine : NSObject

@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) PLogLevel logLevel;
@property (nonatomic, assign) const char * method;
@property (nonatomic, assign) const char * file;
@property (nonatomic, assign) int lineNumber;
@property (nonatomic, unsafe_unretained) id who;
@property (nonatomic, strong) NSThread * thread;
@property (nonatomic, strong) NSDate * timestamp;
@end

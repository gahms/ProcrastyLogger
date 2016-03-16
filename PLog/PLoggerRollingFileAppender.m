#import "PLoggerRollingFileAppender.h"
#import "PLoggerFormatter.h"

#define kPrefKeyCurrentIndex @"PLoggerRollingFileAppender.currentIndex"

@interface PLoggerRollingFileAppender ()
@property (nonatomic) dispatch_queue_t appenderQueue;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSString * currentFileName;
@property (nonatomic, strong) NSFileHandle * currentFile;
@property (nonatomic, strong) NSString * path;
@property (nonatomic, assign) NSInteger maxFiles;
@property (nonatomic, assign) NSInteger bytesWritten;
@property (nonatomic, assign) NSInteger maxFileSize;

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationCachesDirectory;
+ (NSString *)bundleDirectory;
@end

@implementation PLoggerRollingFileAppender

- (id)init
{
    self = [super init];
    if(self) {
        self.appenderQueue
        = dispatch_queue_create("PLoggerRollingFileAppender", DISPATCH_QUEUE_SERIAL);

        self.maxFiles = 10;
        self.currentIndex
        = [[NSUserDefaults standardUserDefaults] integerForKey:kPrefKeyCurrentIndex];

        self.path = [self.class logFilesDir];
        self.maxFileSize = 1000*1000;
        self.logLevel = PL_DEBUG;
        [self rollover];
    }
    return self;
}


- (void)rollover
{
    [_currentFile synchronizeFile];
    [_currentFile closeFile];

    _currentIndex = (_currentIndex + 1) % _maxFiles;

    NSString * bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSString * dir = [self.path stringByAppendingPathComponent:bundleId];

    NSError * error = nil;
    if (![[NSFileManager defaultManager]
          createDirectoryAtPath:dir
          withIntermediateDirectories:YES
          attributes:nil
          error:&error]) {
        NSLog(@"Create directory error: %@", error);
    }

    self.currentFileName
    = [dir stringByAppendingPathComponent:
       [NSString stringWithFormat:@"info_%@.log", @(_currentIndex)]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:_currentFileName
                         contents:nil
                       attributes:nil];
    self.currentFile = [NSFileHandle fileHandleForWritingAtPath:_currentFileName];
    NSLog(@"currentFileName = %@", _currentFileName);
    _bytesWritten = 0;

    [[NSUserDefaults standardUserDefaults]
     setInteger:_currentIndex
     forKey:kPrefKeyCurrentIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)append:(PLoggerLine *)logLine
{
    if(logLine.logLevel < _logLevel) {
        return;
    }
    NSString * formatted = [_formatter format:logLine];
    NSData * data = [formatted dataUsingEncoding:NSUTF8StringEncoding];
    _bytesWritten += [data length];

    dispatch_async(_appenderQueue, ^{
        [_currentFile writeData:data];
        if(_bytesWritten > _maxFileSize) {
            [self rollover];
        }
    });
}

- (void)flush
{
    dispatch_sync(_appenderQueue, ^{
        [_currentFile synchronizeFile];
    });
}

+ (NSString *)applicationDocumentsDirectory
{
	return
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask,
                                         YES)
     lastObject];
}

+ (NSString *)applicationCachesDirectory
{
	return
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                         NSUserDomainMask,
                                         YES)
     lastObject];
}

+ (NSString *)bundleDirectory
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)logFilesDir
{
    NSString * container
    = [self applicationCachesDirectory];
    /*
    = [[NSFileManager defaultManager]
       containerURLForSecurityApplicationGroupIdentifier:@"group.com.companyname.appgroup"]
    .path;
    */
    
    NSString * dir
    = [container
       stringByAppendingPathComponent:@"log"];

    NSError *error;

    if (![[NSFileManager defaultManager]
          createDirectoryAtPath:dir
          withIntermediateDirectories:YES
          attributes:nil
          error:&error]) {
        NSLog(@"Create directory error: %@", error);
    }

    return dir;
}

@end

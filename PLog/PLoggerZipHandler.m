#import <ZipArchive/ZipArchive.h>

#import "PLoggerZipHandler.h"

#import "PLoggerRollingFileAppender.h"
#import "PLogger.h"

@implementation PLoggerZipHandler

static PLogger * logger = nil;
+ (void)initialize
{
    logger = [PLogger getLogger:@"022e74935cd0e497002149efa1f71285"];
}

+ (NSString *)logFilesGlob
{
    return @"*.log";
}

+ (NSString *)clientInformation
{
    NSMutableString * info = [[NSMutableString alloc] init];

    NSDictionary * appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString * appVersion = [appInfo objectForKey:@"CFBundleShortVersionString"];
    NSString * appBuild = [appInfo objectForKey:@"CFBundleVersion"];
    NSString * appID = [appInfo objectForKey:@"CFBundleIdentifier"];
    NSString * appName = [appInfo objectForKey:@"CFBundleName"];

    NSLocale * userLocale = [NSLocale autoupdatingCurrentLocale];
    NSTimeZone * userTimeZone = [NSTimeZone localTimeZone];

    [info appendString:@"<client>\n"];

    [info appendFormat:@"  <applicationVersion>%@</applicationVersion>\n",
     appVersion];
    [info appendFormat:@"  <applicationBuild>%@</applicationBuild>\n",
     appBuild];
    [info appendFormat:@"  <applicationID>%@</applicationID>\n",
     appID];
    [info appendFormat:@"  <applicationName>%@</applicationName>\n",
     appName];

    [info appendFormat:@"  <userLocale>%@</userLocale>\n",
     [userLocale localeIdentifier]];

    [info appendFormat:@"  <userTimeZone>%@</userTimeZone>\n",
     [userTimeZone name]];

    [info appendString:@"</client\n"];

    NSString * filename = [NSString stringWithFormat:@"%@/clientInformation.xml",
                           [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                NSUserDomainMask,
                                                                YES)
                            lastObject]];

    NSError * error = nil;
    BOOL success = [info writeToFile:filename
                          atomically:NO encoding:NSUTF8StringEncoding
                               error:&error];
    if(!success) {
        // TODO: Error handling?
    }

    return filename;
}

+ (NSString *)deviceInformation
{
    NSMutableString * deviceInfo = [[NSMutableString alloc] init];

    UIDevice * device = [UIDevice currentDevice];
    [deviceInfo appendString:@"<device>\n"];

    /*
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Wdeprecated-declarations"
     [deviceInfo appendFormat:@"  <uniqueIdentifier>%@</uniqueIdentifier>\n",
     [device uniqueIdentifier]];
     #pragma clang diagnostic pop
     */

    [deviceInfo appendFormat:@"  <name>%@</name>\n",
     [device name]];

    [deviceInfo appendFormat:@"  <systemName>%@</systemName>\n",
     [device systemName]];

    [deviceInfo appendFormat:@"  <systemVersion>%@</systemVersion>\n",
     [device systemVersion]];

    [deviceInfo appendFormat:@"  <model>%@</model>\n",
     [device model]];

    [deviceInfo appendFormat:@"  <localizedModel>%@</localizedModel>\n",
     [device localizedModel]];

    NSString * userInterfaceIdiom = @"unknown";
    UIUserInterfaceIdiom ii = [device userInterfaceIdiom];
    if(ii == UIUserInterfaceIdiomPhone) {
        userInterfaceIdiom = @"Phone";
    } else if(ii == UIUserInterfaceIdiomPad) {
        userInterfaceIdiom = @"Pad";
    } else {
        userInterfaceIdiom = @"Other";
    }
    [deviceInfo appendFormat:@"  <userInterfaceIdiom>%@</userInterfaceIdiom>\n",
     userInterfaceIdiom];

    [deviceInfo appendString:@"</device>\n"];

    NSString * filename = [NSString stringWithFormat:@"%@/deviceInformation.xml",
                           [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                NSUserDomainMask,
                                                                YES)
                            lastObject]];

    NSError * error = nil;
    BOOL success = [deviceInfo writeToFile:filename
                                atomically:NO
                                  encoding:NSUTF8StringEncoding
                                     error:&error];
    if(!success) {
        // TODO: Error handling?
    }

    return filename;
}

+ (NSString *)applicationCachesDirectory
{
    return
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                         NSUserDomainMask,
                                         YES)
     lastObject];
}

- (NSString *)nowString
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    df.dateFormat = @"yyyyMMdd-HHmmss";

    return [df stringFromDate:[NSDate date]];
}

- (NSString *)zipFileFQN
{
    NSString * deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * zipFilename
    = [NSString stringWithFormat:@"%@_%@_logs.zip", [self nowString], deviceID];
    NSString * zipFilePath
    = [[self.class applicationCachesDirectory]
       stringByAppendingPathComponent:zipFilename];

    return zipFilePath;
}

- (void)addFilesRecursive:(NSString *)dir
               zipArchive:(ZipArchive *)za
                 relative:(NSString *)relativePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error = nil;

    NSArray * files = [fileManager contentsOfDirectoryAtPath:dir error:&error];
    for(NSString * file in files) {
        NSString * fqn = [dir stringByAppendingPathComponent:file];
        BOOL isDir;
        BOOL exists = [fileManager fileExistsAtPath:fqn isDirectory:&isDir];
        if(exists && isDir) {
            [self addFilesRecursive:fqn
                         zipArchive:za
                           relative:[relativePath stringByAppendingPathComponent:file]];
        } else {
            [za addFileToZip:fqn newname:[relativePath stringByAppendingPathComponent:file]];
        }
    }
}

- (NSString *)makeLogsZip
{
    NSString * logsDir = [PLoggerRollingFileAppender logFilesDir];
    NSString * zipFilePath = [self zipFileFQN];

    ZipArchive * za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFilePath];
    [self addFilesRecursive:logsDir
                 zipArchive:za
                   relative:[[zipFilePath lastPathComponent] stringByDeletingPathExtension]];
    [za CloseZipFile2];

    return zipFilePath;
}
@end

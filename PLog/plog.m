#include "plog.h"
                             
static NSDateFormatter * getDateFormatter()
{
    static __strong NSDateFormatter * df = nil;
    
    if(df == nil) {
        df = [[NSDateFormatter alloc] init];
        //[df setDateStyle:NSDateFormatterNoStyle];
        //[df setTimeStyle:NSDateFormatterLongStyle];
        [df setDateFormat:@"HH:mm:ss.SSS"];
    }
    
    return df;
}

void _plog(const char *file, int lineNumber, const char *funcName, id who,
           NSString *format,...) 
{
    va_list ap;
	
    va_start(ap, format);
	NSString *body =  [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
    
	//const char *threadName = [[[NSThread currentThread] name] UTF8String];
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSString *ts = [getDateFormatter() stringFromDate:[NSDate date]];
    fprintf(stderr,"%s 0x%x %s %s(%d) %s\n", [ts UTF8String], (unsigned int)who,
            funcName, [fileName UTF8String], lineNumber,
            [body UTF8String]);
}


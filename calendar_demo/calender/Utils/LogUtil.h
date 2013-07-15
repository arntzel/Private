#import <Foundation/Foundation.h>

#define LOG_LEVEL_DEBUG 1
#define LOG_LEVEL_INFO 2
#define LOG_LEVEL_WARN 3
#define LOG_LEVEL_ERROR 4

// Setting
#ifndef LOG_LEVEL
#define LOG_LEVEL LOG_LEVEL_DEBUG
#endif

#  define LOG(logtype,fmt, ...) do {                                            \
NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; \
NSLog((@"%s%@(%d) " fmt), logtype,[file lastPathComponent], __LINE__, ##__VA_ARGS__); \
} while(0)

#  define LOG_P(logtype,fmt, ...) NSLog((@"%s" fmt), logtype, ##__VA_ARGS__)
#  define TRACE(x) LOG_TRACE (x)


#if LOG_LEVEL <= LOG_LEVEL_DEBUG
#  define LOG_METHOD NSLog(@"%s", __func__)
#  define LOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define LOG_COUNT(p) NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
#  define LOG_TRACE(fmt,...) do {printf (fmt,##__VA_ARGS__); putchar('\n'); fflush(stdout);} while (0);
#else
#  define LOG_METHOD
#  define LOG_CMETHOD
#  define LOG_COUNT(p)
#  define LOG_TRACE(...)
#endif



#if LOG_LEVEL <= LOG_LEVEL_DEBUG
#define LOG_D(fmt,...)  LOG("",fmt,##__VA_ARGS__)
#else
#define LOG_D(...)
#endif

#if LOG_LEVEL <= LOG_LEVEL_INFO
#define LOG_I(fmt, ...) LOG("I>: ",fmt,##__VA_ARGS__)
#else
#define LOG_I(...) 
#endif

#if LOG_LEVEL <= LOG_LEVEL_WARN
#define LOG_W(fmt, ...)   LOG("W>: ",fmt,##__VA_ARGS__)
#else
#define LOG_W(...) 
#endif

#if LOG_LEVEL <= LOG_LEVEL_ERROR
#define LOG_E(fmt, ...)  LOG("E>: ",fmt,##__VA_ARGS__)
#else
#define LOG_E(...) 
#endif

// .h文件
#define HMSingletonH(name)   + (instancetype)shared##name;

// .m文件
#if __has_feature(objc_arc)
    #define HMSingletonM(name) \
    static id _instance; \
     \
    + (id)allocWithZone:(struct _NSZone *)zone \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instance = [super allocWithZone:zone]; \
        }); \
        return _instance; \
    } \
     \
    + (instancetype)shared##name \
    { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instance = [[self alloc] init]; \
        }); \
        return _instance; \
    } \
     \
    - (id)copyWithZone:(NSZone *)zone \
    { \
        return _instance; \
    }

#else
    #define HMSingletonM(name) \
    static id _instance; \
    \
    + (id)allocWithZone:(struct _NSZone *)zone \
    { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
    } \
    \
    + (instancetype)shared##name \
    { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instance = [[self alloc] init]; \
    }); \
    return _instance; \
    } \
    \
    - (id)copyWithZone:(NSZone *)zone \
    { \
    return _instance; \
    } \
     \
    - (oneway void)release { } \
    - (id)retain { return self; } \
    - (NSUInteger)retainCount { return 1;} \
    - (id)autorelease { return self;}

#endif

@interface Bookmark: NSObject <NSCoding>


@property (nonatomic, assign) BOOL isApp;

@property (nonatomic, retain) NSString* bundleID;

@property (nonatomic, retain) NSURL *URL;

@property (nonatomic, strong) NSString *name;

- (NSURL*)getAppDataURL;

- (instancetype)initForNonAppWithName:(NSString*)name URL:(NSURL*)path;

- (instancetype)initForAppWithName:(NSString*)name bundleID:(NSString*)bid;


@end

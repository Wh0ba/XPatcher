
@protocol FMDelegate <NSObject>
@optional
- (void)setURL:(NSURL *)url forFieldTag:(int)tf;
@end


@interface FMController: UITableViewController <UIDocumentPickerDelegate>

- (instancetype)initWithPath:(NSURL *)path;

- (instancetype)initWithTarget:(int)target;
- (instancetype)initWithPath:(NSURL *)path andBundleID:(NSString*)bid;

@property (nonatomic, weak) id<FMDelegate> delegate;

@end



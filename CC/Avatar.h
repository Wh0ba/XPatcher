


@interface Avatar: NSObject {
    NSURL *documentsDirectory;
    UIImage *_fileIcon;
    UIImage *_folderIcon;
    NSArray *_notOkPaths;
    NSFileManager *fileManager;
}

@property (nonatomic, retain) NSURL *documentsDirectory;
@property (nonatomic, strong) UIImage *fileIcon;
@property (nonatomic, strong) UIImage *folderIcon;
@property (nonatomic, retain) NSFileManager *fileManager;
@property (nonatomic, strong) NSArray *notOkPaths;

+ (id)shared;

- (void)alertWithTitle:(NSString *)tot message:(NSString *)mes;

- (NSString *)fileSizeAtFullPath:(NSURL *)fullPath;

- (BOOL)isPatchFileAtURL:(NSURL*)file;



@end

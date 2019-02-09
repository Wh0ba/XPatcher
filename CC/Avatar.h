#import "Bookmark.h"




@interface Avatar: NSObject {
    NSURL *documentsDirectory;
    UIImage *_fileIcon;
    UIImage *_folderIcon;
}

@property (nonatomic, retain) NSURL *documentsDirectory;
@property (nonatomic, strong) UIImage *fileIcon;
@property (nonatomic, strong) UIImage *folderIcon;

+ (id)shared;

- (void)alertWithTitle:(NSString *)tot message:(NSString *)mes;




@end

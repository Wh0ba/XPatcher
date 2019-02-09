#import "Avatar.h"
#import "../shared.h"
#import <LSApplicationWorkspace.h>

@implementation Avatar

@synthesize documentsDirectory;


#pragma mark Singleton Methods

+ (id)shared {
    static Avatar *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
      documentsDirectory = [NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0]];
  }
  return self;
}

- (UIImage*) folderIcon {
	
	if (!_folderIcon) {
		_folderIcon = [UIImage imageNamed:@"icons/folder.png"];
	}
	
	return _folderIcon;
}

- (UIImage*) fileIcon {
	if (!_fileIcon) {
		_fileIcon = [UIImage imageNamed:@"icons/file.png"];
	}
	
	return _fileIcon;
}

- (void)alertWithTitle:(NSString *)tot message:(NSString *)mes 
{
	
	UIAlertView *allert = [[UIAlertView alloc] initWithTitle:tot message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[allert show];
	
}






@end
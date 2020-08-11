#import "Avatar.h"

@implementation Avatar {
	NSUserDefaults *defaults;
	
}

@synthesize documentsDirectory, fileManager;

static NSString *const themeKey = @"XPatcher.currentTheme";
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
	
		
		if (!documentsDirectory) documentsDirectory = [NSURL URLWithString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)[0]];
		
		fileManager = [NSFileManager defaultManager];
		defaults = [NSUserDefaults standardUserDefaults];
		self.currentTheme = [defaults integerForKey:themeKey] ?: XPThemeDark;
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


- (void)setTheme:(XPTheme)theme {
	self.currentTheme = theme;
	[defaults setInteger:theme forKey:themeKey];
	
	[[NSNotificationCenter defaultCenter] 
       postNotificationName:kChangeThemeNotification
        object:nil userInfo:nil];
}

- (void)alertWithTitle:(NSString *)tot message:(NSString *)mes 
{
	
	UIAlertView *allert = [[UIAlertView alloc] initWithTitle:tot message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[allert show];
	
}


- (BOOL)isPatchFileAtURL:(NSURL*)file {
	
	
	
	NSString* ext = [file.pathExtension lowercaseString];
	
	NSArray *supportedExtensions = @[
	@"ups",
	@"ips",
	@"ppf",
	@"bps",
	@"rup",
	@"delta",
	@"dat",
	@"xdelta",
	];
	if ([supportedExtensions containsObject:ext]) return YES;
	
	
	return NO;
	
}

- (BOOL)isROMFileAtURL:(NSURL*)file {
	
	
	
	NSString* ext = [file.pathExtension lowercaseString];
	
	NSArray *supportedExtensions = @[
	@"gba",
	@"gb",
	@"gbc",
	@"nes",
	@"smc",
	@"sfc",
	@"iso",
	@"ds",
	];
	if ([supportedExtensions containsObject:ext]) return YES;
	
	
	return NO;
}


- (NSArray*)notOkPaths {
	
	if (!_notOkPaths){
	
	_notOkPaths = @[
		@"/var/mobile/Library",
		@"/var/mobile/Containers",
		@"/var/mobile/Media/DCIM",
		@"/var/mobile/Media/Books",
		@"/var/mobile/Media/Downloads",
		@"/var/mobile/Media/general_storage",
		@"/var/mobile/Media/iTunes_Control",
		@"/var/mobile/Media/MediaAnalysis",
		@"/var/mobile/Media/Memories",
		@"/var/mobile/Media/PhotoData",
		@"/var/mobile/Media/Photos",
		@"/var/mobile/Media/Podcasts",
		@"/var/mobile/Media/Recordings",
		@"/var/mobile/Media/PublicStaging",
		@"/var/mobile/MobileSoftwareUpdate"
	];
	}
	return _notOkPaths;
}



- (BOOL)isSafeDirAtURL:(NSURL*)url {
	/*
	if (self.inAppDir) {
		if (!self.allowDeletingFromApps) return NO;
		return YES;
	}*/
	
	if ([url.path rangeOfString:[self documentsDirectory].path options:NSCaseInsensitiveSearch].location != NSNotFound) {
		return YES;
	}
	
	
	if ([url.path rangeOfString:@"/var/mobile" options:NSCaseInsensitiveSearch].location == NSNotFound || [url.path rangeOfString:@"/private/var/mobile" options:NSCaseInsensitiveSearch].location == NSNotFound) return NO;
	
	
	for (NSString* badPath in [self notOkPaths]) {
		
		if ([url.path rangeOfString:badPath options:NSCaseInsensitiveSearch].location != NSNotFound) return NO;
		
	}
	
	return YES;
}


- (NSString *)fileSizeAtFullPath:(NSURL *)fullPath {
	
	NSError *error;
	NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:fullPath.path error:&error]; 
	
	if (error) {
		[self alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
		return @"error";
	}
	
	return [NSByteCountFormatter stringFromByteCount:[fileAttr fileSize] countStyle:NSByteCountFormatterCountStyleFile];

}




@end

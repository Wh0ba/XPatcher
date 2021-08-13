#import "../shared.h"
#import "../defs.h"
#import "FMController.h"


static NSString *CellIdentifier = @"Cell";


@interface FMController() 

@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) BOOL exCall;
@property (nonatomic, assign) BOOL forField;
@property (nonatomic, assign) BOOL showHiddenFiles;
@property (nonatomic, assign) BOOL inAppDir;
@property (nonatomic, assign) NSString *appBundleID;
@property (nonatomic, assign) BOOL allowDeletingFromApps;

@end

@implementation FMController {
	
	NSFileManager *fileManager;
	
	NSMutableArray *dirCon;

 Avatar *Korra;	
}
@synthesize exCall, currentURL, showHiddenFiles, allowDeletingFromApps;




#pragma mark -
#pragma mark Initializers


- (instancetype)initWithPath:(NSURL *)path {
	
	self = [super initWithStyle:UITableViewStylePlain];
	
		if (self) {
		
		self.exCall = YES;
		self.forField = NO;
		self.currentURL = path;
		self.title = [path lastPathComponent];
		
	}
	return self;
}
- (instancetype)initWithPath:(NSURL *)path andBundleID:(NSString*)bid {
	
	self = [super initWithStyle:UITableViewStylePlain];
	if (!self) return nil;
	
	self.exCall = YES;
	self.forField = NO;
	self.currentURL = path;
	self.appBundleID = bid;
	self.inAppDir = true;
	
	self.title = [path lastPathComponent];
	
	return self;
}



#pragma mark view loading
- (void)loadView {
	
	[super loadView];
	Korra = [Avatar shared];	
	self.view.backgroundColor = kBgcolor;
	fileManager = [NSFileManager defaultManager];

	showHiddenFiles = YES;
	allowDeletingFromApps = NO;
	
	[self navBarMagic];
	[self applyTheme];

	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	
	[self loadContent];

	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(reloadContent) 
        name:kFMReloadContent
        object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(reloadContent) 
        name:UIApplicationWillEnterForegroundNotification
        object:nil];
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(applyTheme) 
        name:kChangeThemeNotification
        object:nil];

}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}



#pragma mark -
#pragma mark LoadContent


- (void)loadContent {
	
	NSUInteger flag = showHiddenFiles ? 0 : NSDirectoryEnumerationSkipsHiddenFiles;	
	
	NSArray *dirURLs = @[];
	
	if (exCall) {
		NSError *err;
		
		//check if the directory doesn't exist
		if (!currentURL || ![fileManager fileExistsAtPath:currentURL.path isDirectory:nil]) {
			[Korra alertWithTitle:@"Error" message:[NSString stringWithFormat:@"Folder doesn't exsist"]];
			
			dirURLs = @[];
			
			[self.navigationController popViewControllerAnimated:YES];
			
			
		}else {
			dirURLs = [fileManager contentsOfDirectoryAtURL:currentURL includingPropertiesForKeys:nil options:flag error:&err];
			
			if (err) {
				[Korra alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[err localizedDescription]]];
			}
		}
	}else {
		
		currentURL = Korra.documentsDirectory;
		NSError *err;
		dirURLs = [fileManager contentsOfDirectoryAtURL:currentURL includingPropertiesForKeys:nil options:flag error:&err];
		
		
		if (err) {
			[Korra alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[err localizedDescription]]];
		}
	}
	
	
	self.title = [currentURL lastPathComponent];
	
	dirCon = [dirURLs mutableCopy];
	
	[dirCon sortUsingComparator:^NSComparisonResult(NSURL* a, NSURL* b) {
		return [a.path caseInsensitiveCompare:b.path];
	}];;
	dirURLs = nil;
}



#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return dirCon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.numberOfLines = 0;
	
	cell.textLabel.textColor = Korra.currentTheme == XPThemeDark ? White : Black;
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	NSURL *fileURL = dirCon[indexPath.row];
	
	cell.textLabel.text = urlToString(fileURL);
	
	cell.contentView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = Korra.currentTheme == XPThemeDark ? White : Black;
	
	NSNumber* isFile;
    [fileURL getResourceValue:&isFile forKey:NSURLIsRegularFileKey error:nil];
	
	
	if (![isFile boolValue]) {
	
		cell.detailTextLabel.text = @"Folder";
		//cell.textLabel.textColor = [UIColor blueColor];
		cell.imageView.image = [Korra folderIcon];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		cell.accessoryView = nil;
		
	}else {
		
		if ([Korra isPatchFileAtURL:fileURL]) cell.textLabel.textColor = kDefPatchColor;
		
		if ([Korra isROMFileAtURL:fileURL]) cell.textLabel.textColor = kDefROMColor;
		cell.imageView.image = [Korra fileIcon];
		//Remove possibly reused arrow on the right
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		//Create sizeLabel from filesize and set it to accessoryView
		UILabel* sizeLabel = [[UILabel alloc] init];
		sizeLabel.text = [Korra fileSizeAtFullPath:fileURL];
		sizeLabel.textColor = [UIColor lightGrayColor];
		sizeLabel.font = [sizeLabel.font fontWithSize:10];
		sizeLabel.textAlignment = NSTextAlignmentCenter;
		sizeLabel.frame = CGRectMake(0,0, sizeLabel.intrinsicContentSize.width, 15);
		cell.accessoryView = sizeLabel;
	}
	

}

#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSURL *fileURL = dirCon[indexPath.row];
	
	if (![fileManager fileExistsAtPath:fileURL.path isDirectory:nil]) {
		[Korra alertWithTitle:@"Error" message:[NSString stringWithFormat:@"File doesn't exist"]];
		return;
	}
	
	NSNumber *isFile;
    [fileURL getResourceValue:&isFile forKey:NSURLIsRegularFileKey error:nil];
	
	
	if (![isFile boolValue]) {
		FMController *inside = [[FMController alloc] initWithPath:fileURL];
		if (self.inAppDir) inside.inAppDir = YES;
		[self.navigationController pushViewController:inside animated:YES];
	}else {
			[self actionsForFileAtURL:fileURL];
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


#pragma mark -
#pragma mark my methods
- (void)buttonActions:(id)sender {

	switch ([sender tag]) {
		case 1:
			[self dismissViewControllerAnimated:YES completion:nil];
			break; 
		default:
			break;
	}
}


- (void)actionsForFileAtURL:(NSURL*)url {

	UIAlertController *actionSheet = [UIAlertController 
		alertControllerWithTitle:url.lastPathComponent 
		message:nil 
		preferredStyle:UIAlertControllerStyleActionSheet];

	[actionSheet addAction:
		[UIAlertAction 
			actionWithTitle:@"Cancel" 
			style:UIAlertActionStyleCancel 
			handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:^{}];
			}
		]
	];

	if ([Korra isPatchFileAtURL:url]) {
		if (Korra.isApplyPatchMode){
			[actionSheet addAction:
				[UIAlertAction 
					actionWithTitle:@"Set patch" 
					style:UIAlertActionStyleDefault 
					handler:^(UIAlertAction *action) {
						NSDictionary *userInfo = @{@"fileURL":url,@"tag":@2};
						[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
					}
				]
			];
		}
	}
	else {
		[actionSheet addAction:
			[UIAlertAction 
				actionWithTitle:(Korra.isApplyPatchMode) ? @"Set ROM" : @"Set original ROM" 
				style:UIAlertActionStyleDefault 
				handler:^(UIAlertAction *action) {
					NSDictionary *userInfo = @{@"fileURL":url,@"tag":@1};
					[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
				}
			]
		];
		if (!Korra.isApplyPatchMode) {
			[actionSheet addAction:
			[UIAlertAction 
				actionWithTitle:@"Set Modified ROM" 
				style:UIAlertActionStyleDefault 
				handler:^(UIAlertAction *action) {
					NSDictionary *userInfo = @{@"fileURL":url,@"tag":@3};//tag 3 means set it as the modified rom
					[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
				}
			]
		];
		}
	}
	[actionSheet addAction:
		[UIAlertAction 
			actionWithTitle:@"Open In" 
			style:UIAlertActionStyleDefault 
			handler:^(UIAlertAction *action) {
				UIActivityViewController* OpenInVC =[[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
				[self presentViewController:OpenInVC animated:YES completion:nil];
			}	
		]
	];

	if ([Korra isSafeDirAtURL:url]) {
		
		[actionSheet 
			addAction:
				[UIAlertAction 
					actionWithTitle:@"Delete" 
					style:UIAlertActionStyleDestructive 
					handler:^(UIAlertAction *action) {	
						UIAlertController *deleteAlert = [UIAlertController 
															alertControllerWithTitle:@"Warning" 
															message:[NSString stringWithFormat:@"are you sure you want to delete %@",url.lastPathComponent] 
															preferredStyle:UIAlertControllerStyleAlert];

						[deleteAlert 
							addAction:
								[UIAlertAction 
									actionWithTitle:@"Cancel" 
										style:UIAlertActionStyleCancel 
										handler:^(UIAlertAction *action) {
										[self dismissViewControllerAnimated:YES completion:^{}];
										}
								]
						];
					
						[deleteAlert 
							addAction:
								[UIAlertAction 
									actionWithTitle:@"Delete" 
									style:UIAlertActionStyleDestructive 
									handler:^(UIAlertAction *action) {
										NSError *erro;
										
										if (![fileManager removeItemAtURL:url error:&erro]) {
											NSString *errText = [NSString stringWithFormat:@"Error, %@", [erro localizedDescription]];
											[self.view makeToast:errText duration:3.0 position:CSToastPositionTop];	
										}else {
											[[[UIApplication sharedApplication] keyWindow] makeToast:[NSString stringWithFormat:@"Removed File: %@", url.lastPathComponent] duration:1 position:CSToastPositionTop];
											[self reloadContent];
										}								
									}
								]
						];
					
						[self presentViewController:deleteAlert animated:YES completion:nil];
					
		}]];
} // if not inApp

// Present action sheet.
[self presentViewController:actionSheet animated:YES completion:nil];
}


- (void) reloadContent {
	[self loadContent];
	[self.tableView reloadData];
}

- (void)pulledToRefresh {
	[self reloadContent];
	[self.refreshControl endRefreshing];
}




- (void)navBarMagic {
	
	self.navigationController.navigationBar.translucent = NO;
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	

	
	UIBarButtonItem* importFilesButton = [[UIBarButtonItem alloc] 
		initWithTitle:@"Import" 
		style:UIBarButtonItemStylePlain 
		target:self 
		action:@selector(startUIDocumentPickerForImport)];
	
	self.navigationItem.rightBarButtonItem = importFilesButton;
	
}


- (void)startUIDocumentPickerForImport {
	 UIDocumentPickerViewController *documentPicker = 
	 	[[UIDocumentPickerViewController alloc] 
		 initWithDocumentTypes:@[@"public.data"]
         inMode:UIDocumentPickerModeImport];
    
	documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}


- (void)unselectRow
{
  NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
  if(selectedIndexPath)
  {
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
  }
}


- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
		

		NSMutableArray *pathComps = [[NSMutableArray alloc] init];
		for (NSURL *URL in urls){
			NSError *fileError;
			

			NSData *fileData = [NSData dataWithContentsOfURL:URL];
			NSString *newPath = [Korra.documentsDirectory.path stringByAppendingPathComponent:URL.lastPathComponent];
			[fileData writeToFile:newPath options:NSDataWritingWithoutOverwriting error:&fileError];
			if (fileError) {
				[Korra alertWithTitle:@"Importing Error" message:[NSString stringWithFormat:@"%@, url: %@",[fileError localizedDescription], URL.description]];
				continue;
			}
			fileData = nil;
			
			[pathComps addObject:URL.lastPathComponent];

			NSError *fileDeleteError;
			[fileManager removeItemAtURL:URL error:&fileDeleteError];
		}


		
		if (pathComps.count <= 0) return; 

		dispatch_async(dispatch_get_main_queue(), ^{
			[self reloadContent];
		});
	
    }
}


- (void)applyTheme {
	if (Korra.currentTheme == XPThemeLight){



		self.view.backgroundColor = White;

		self.navigationController.navigationBar.barTintColor = kMelroseColor;

		self.navigationController.navigationBar.tintColor = White;



		if (self.tabBarController.tabBar){
			self.tabBarController.tabBar.barTintColor = kMelroseColor;
			self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
			self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithWhite:0.4 alpha:1];
		}

	}else if (Korra.currentTheme == XPThemeDark){


		UIColor *backgroundColor = [UIColor blackColor];
		self.view.backgroundColor = backgroundColor;

		self.navigationController.navigationBar.barTintColor = backgroundColor;

		self.navigationController.navigationBar.tintColor = kMelroseColor;
		
		[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:White}];

		if (self.tabBarController.tabBar){
			self.tabBarController.tabBar.barTintColor = backgroundColor;
			self.tabBarController.tabBar.tintColor = kMelroseColor;
			self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorWithWhite:0.7 alpha:1];
		}
	}
	[self reloadContent];
}


@end

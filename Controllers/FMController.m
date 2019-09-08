#import "../shared.h"
#import "FMController.h"


static NSString *CellIdentifier = @"Cell";









@interface FMController() 

//@property (nonatomic, strong) NSString *currentPath;
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
	
	//id parent, target;
	int targetTag;// 1 = rom , 2 = patch
	
	Avatar *Korra;
	
}
@synthesize exCall, currentURL, showHiddenFiles, allowDeletingFromApps;



- (void)loadView {
	
	[super loadView];
	
	self.view.backgroundColor = kBgcolor;
	
	
	fileManager = [NSFileManager defaultManager];
	
	Korra = [Avatar shared];
	
	showHiddenFiles = NO;
	allowDeletingFromApps = NO;
	
	//self.tableView.allowEditing = NO;
	
	//[self setNav];
	
	
	self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	[self navBarMagic];
	
	[self loadContent];
	
//	if (![currentURL isEqual:Korra.documentsDirectory])[self setNav];


	[[NSNotificationCenter defaultCenter] 		addObserver:self
	selector:@selector(reloadContent) 
        name:kFMReloadContent
        object:nil];
	
	
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	
}



#pragma mark -
#pragma mark Initilizers

- (instancetype)initWithTarget:(int)tar {
	
	self = [super initWithStyle:UITableViewStylePlain];
	
		if (self) {
		
		//parent = par;
		targetTag = tar;
		self.forField = YES;
		self.title = [Korra.documentsDirectory lastPathComponent];
		}
	
	
	return self;
}

- (instancetype)initWithPath:(NSURL *)path {
	
	self = [super initWithStyle:UITableViewStylePlain];
	
		if (self) {
		
		//self.currentPath = path;
		self.exCall = YES;
		self.forField = NO;
		self.currentURL = path;
		
		
		//[self loadContent];
		self.title = [path lastPathComponent];
		
	}
	return self;
}
- (instancetype)initWithPath:(NSURL *)path andBundleID:(NSString*)bid {
	
	self = [super initWithStyle:UITableViewStylePlain];
	if (!self) return nil;
	
	//self.currentPath = path;
	self.exCall = YES;
	self.forField = NO;
	self.currentURL = path;
	self.appBundleID = bid;
	self.inAppDir = true;
	
	//[self loadContent];
	self.title = [path lastPathComponent];
	
	return self;
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
}


#pragma mark -
#pragma mark bookmarks
/*
- (void)addBookmarkAlert {
	
	UIAlertController *bookmarkAlert = [UIAlertController alertControllerWithTitle:@"Add Bookmark" message:nil preferredStyle:UIAlertControllerStyleAlert];

	[bookmarkAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

            // Cancel button tappped.
		[self dismissViewControllerAnimated:YES completion:^{}];
	}]];
	
	[bookmarkAlert addTextFieldWithConfigurationHandler:^(UITextField *nameTF){
		
		nameTF.placeholder = @"bookmark Name";
		nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		nameTF.borderStyle = UITextBorderStyleRoundedRect;
		nameTF.backgroundColor = Clear;
		
	}];
	
	
	
	[bookmarkAlert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	
	NSString *name = bookmarkAlert.textFields[0].text;
	
	
	[self addBookmarkWithName:name];
	
	[self dismissViewControllerAnimated:YES completion:^{}];
	}]];
	
	
	
	
	
	
// Present action sheet.
	[self presentViewController:bookmarkAlert animated:YES completion:nil];
	
	
	
}



- (void)addBookmarkWithName:(NSString*)name {
	
	
	if (!name) {
		name = currentURL.path.lastPathComponent;
	}
	if ([name isEqualToString:@""]) {
		name = currentURL.path.lastPathComponent;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	
	NSData *serializedIn = [defaults objectForKey:@"bookmarks"];
	NSMutableArray *bookmarks = [[NSKeyedUnarchiver unarchiveObjectWithData:serializedIn] mutableCopy];
	
	Bookmark *newbm = [self createBookmarkFromURL:currentURL name:name];
	
	
	if (!bookmarks) {
		
		
		bookmarks = [@[newbm] mutableCopy];
		
		
	}else {
		
		[bookmarks addObject:newbm];
		
	}
	
	NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:bookmarks];
	[defaults setObject:serialized forKey:@"bookmarks"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kBookmarksReload object:nil userInfo:nil];
	
}

- (Bookmark*)createBookmarkFromURL:(NSURL*)url name:(NSString*)name{
	
	if (self.inAppDir) {
		
		return [[Bookmark alloc] initForAppWithName:name bundleID:self.appBundleID];
		
	}else {
		return [[Bookmark alloc] initForNonAppWithName:name URL:url];
	}
}
*/

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
	
	cell.textLabel.textColor = Black;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	//NSString *fileName = dirCon[indexPath.row];
	
	NSURL *fileURL = dirCon[indexPath.row];
	
	cell.textLabel.text = urlToString(fileURL);
	
	cell.contentView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];
	
	
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
	
	
	
	//static NSString *fileName;
	
	NSURL *fileURL = dirCon[indexPath.row];
	
	
	if (![fileManager fileExistsAtPath:fileURL.path isDirectory:nil]) {
		[Korra alertWithTitle:@"Error" message:[NSString stringWithFormat:@"File doesn't exsist"]];
		return;
	}
	
	
	NSNumber *isFile;
    [fileURL getResourceValue:&isFile forKey:NSURLIsRegularFileKey error:nil];
	
	
		if (![isFile boolValue]) {
			FMController *inside = [[FMController alloc] initWithPath:fileURL];
			if (self.inAppDir) inside.inAppDir = YES;
			[self.navigationController pushViewController:inside animated:YES];
		}else {
		if (_forField) {
			
			if ([self.delegate conformsToProtocol:@protocol(FMDelegate)]) {
				[self.delegate setURL:fileURL forFieldTag:targetTag];
			}
			
			[self dismissViewControllerAnimated:YES completion:nil];
			
		}else {
				[self actionsForFileAtURL:fileURL];
				[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		}


		}
	
	
}


#pragma mark -
#pragma mark my methods
/*
- (void)setNav {
	
	
	
	UIBarButtonItem *addFav = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonActions:)];
	addFav.tag = 2;
	
	self.navigationItem.rightBarButtonItem = addFav;
	
	//UIBarButtonSystemItemSave
	
}
*/
- (void)buttonActions:(id)sender {
	
	int tg = [sender tag];
	
	switch (tg) {
		case 1:
			[self dismissViewControllerAnimated:YES completion:nil];
			break; 
		case 2: 
			
			//[self addBookmarkAlert];
			
			break;
		default:
			
			break;
	}
}


- (void)actionsForFileAtURL:(NSURL*)url {
	
	
	UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:url.lastPathComponent message:nil preferredStyle:UIAlertControllerStyleActionSheet];

	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

            // Cancel button tappped.
		[self dismissViewControllerAnimated:YES completion:^{}];
}]];

if ([Korra isPatchFileAtURL:url]) {

[actionSheet addAction:[UIAlertAction actionWithTitle:@"set Patch" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	
	NSDictionary *userInfo = @{@"fileURL":url,@"tag":@2};
	[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
	
}]];
}
	else {
		[actionSheet addAction:[UIAlertAction actionWithTitle:@"set ROM" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	
			NSDictionary *userInfo = @{@"fileURL":url,@"tag":@1};
			[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
		
		}]];
	}
[actionSheet addAction:[UIAlertAction actionWithTitle:@"Open In" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	UIActivityViewController* OpenInVC =[[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
	[self presentViewController:OpenInVC animated:YES completion:nil];
}]];

/*
[actionSheet addAction:[UIAlertAction actionWithTitle:@"Open In Filza" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	 NSString* filzaPath = [NSString stringWithFormat:@"%@%@", @"filza://view", [url.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]]; 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:filzaPath]];
}]];
*/
if ([Korra isSafeDirAtURL:url]) {
	
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		
		
		
			UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Warning" message:[NSString stringWithFormat:@"are you sure you want to delete %@",url.lastPathComponent] preferredStyle:UIAlertControllerStyleAlert];

			[deleteAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
				[self dismissViewControllerAnimated:YES completion:^{}];
			}]];
		
			[deleteAlert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
				
				NSError *erro;
				
				if (![fileManager removeItemAtURL:url error:&erro]) {
					NSString *errText = [NSString stringWithFormat:@"Error, %@", [erro localizedDescription]];
					[self.view makeToast:errText duration:3.0 position:CSToastPositionTop];
					
				}else {
					[self.view makeToast:[NSString stringWithFormat:@"Removed File: %@", url.lastPathComponent] duration:1 position:CSToastPositionTop];
					[self reloadContent];
				}
				
			}]];
			
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
	
	self.navigationController.navigationBar.barTintColor = kMelroseColor;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	
	
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


/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/

@end

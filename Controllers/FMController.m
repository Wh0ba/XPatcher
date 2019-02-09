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

@end

@implementation FMController {
	
	NSFileManager *fileManager;
	
	NSMutableArray *dirCon;
	
	//id parent, target;
	int targetTag;// 1 = rom , 2 = patch
	
	Avatar *kora;
	
}
@synthesize exCall, currentURL, showHiddenFiles;



- (void)loadView {
	
	[super loadView];
	
	self.view.backgroundColor = kBgcolor;
	
	
	fileManager = [NSFileManager defaultManager];
	
	kora = [Avatar shared];
	
	showHiddenFiles = NO;
	
	
	//self.tableView.allowEditing = NO;
	
	//[self setNav];
	
	
	self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(pulledToRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	[self navBarMagic];
	
	[self loadContent];
	
	if (![currentURL isEqual:kora.documentsDirectory])[self setNav];
	
	
	
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	
}

- (void)navBarMagic {
	
	self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	
	
}


- (instancetype)initWithTarget:(int)tar {
	
	self = [super initWithStyle:UITableViewStylePlain];
	
		if (self) {
		
		//parent = par;
		targetTag = tar;
		self.forField = YES;
		self.title = [kora.documentsDirectory lastPathComponent];
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

- (void)setNav {
	
	
	
	UIBarButtonItem *addFav = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonActions:)];
	addFav.tag = 2;
	
	self.navigationItem.rightBarButtonItem = addFav;
	
	//UIBarButtonSystemItemSave
	
}

- (void)buttonActions:(id)sender {
	
	int tg = [sender tag];
	
	switch (tg) {
		case 1:
			[self dismissViewControllerAnimated:YES completion:nil];
			break; 
		case 2: 
			
			[self addBookmarkAlert];
			
			break;
		default:
			
			break;
	}
}


#pragma mark -
#pragma mark bookmarks

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






- (void)loadContent {
	
	NSUInteger flag = showHiddenFiles ? 0 : NSDirectoryEnumerationSkipsHiddenFiles;
	
	
	
	
	NSArray *dirURLs = @[];
	
	if (exCall) {
		NSError *err;
		dirURLs = [fileManager contentsOfDirectoryAtURL:currentURL includingPropertiesForKeys:nil options:flag error:&err];
		
		if (err) {
			[kora alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[err localizedDescription]]];
		}
		
	}else {
		
		currentURL = kora.documentsDirectory;
		NSError *err;
		dirURLs = [fileManager contentsOfDirectoryAtURL:currentURL includingPropertiesForKeys:nil options:flag error:&err];
		
		
		if (err) {
			[kora alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[err localizedDescription]]];
		}
	}
	
	
	self.title = [currentURL lastPathComponent];
	
	dirCon = [dirURLs mutableCopy];
	
	[dirCon sortUsingComparator:^NSComparisonResult(NSURL* a, NSURL* b) {
		return [a.path caseInsensitiveCompare:b.path];
	}];;
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
		cell.imageView.image = [kora folderIcon];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		cell.accessoryView = nil;
		
	}else {
		
		cell.imageView.image = [kora fileIcon];
		//Remove possibly reused arrow on the right
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		//Create sizeLabel from filesize and set it to accessoryView
		UILabel* sizeLabel = [[UILabel alloc] init];
		sizeLabel.text = [self fileSizeAtFullPath:fileURL];
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
	
	
	static NSURL *fileURL;
	//static NSString *fileName;
	
	fileURL = dirCon[indexPath.row];
	
	
	NSNumber *isFile;
    [fileURL getResourceValue:&isFile forKey:NSURLIsRegularFileKey error:nil];
	
	
		if (![isFile boolValue]) {
			FMController *inside = [[FMController alloc] initWithPath:fileURL];
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


- (void)actionsForFileAtURL:(NSURL*)url {
	
	
	UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:url.lastPathComponent message:nil preferredStyle:UIAlertControllerStyleActionSheet];

	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

            // Cancel button tappped.
		[self dismissViewControllerAnimated:YES completion:^{}];
}]];

if ([self isPatchFileAtURL:url]) {

[actionSheet addAction:[UIAlertAction actionWithTitle:@"set Patch" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	
	NSDictionary *userInfo = @{@"fileURL":url,@"tag":@2};
	[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
	
}]];
}

[actionSheet addAction:[UIAlertAction actionWithTitle:@"set ROM" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	
	NSDictionary *userInfo = @{@"fileURL":url,@"tag":@1};
	[[NSNotificationCenter defaultCenter] postNotificationName:kSetFileNotification object:nil userInfo:userInfo];
	
}]];


[actionSheet addAction:[UIAlertAction actionWithTitle:@"Open In Filza" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	 NSString* filzaPath = [NSString stringWithFormat:@"%@%@", @"filza://view", [url.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]]; 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:filzaPath]];
}]];
/*
[actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

// Distructive button tapped.
[self dismissViewControllerAnimated:YES completion:^{
		
		
		NSError *erro;
			[fileManager removeItemAtURL:url error:&erro];
			
			if (erro) {
				[self alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[erro localizedDescription]]];
			}
		
		
	}];
	
}]];
*/

// Present action sheet.
[self presentViewController:actionSheet animated:YES completion:nil];
}



- (void)pulledToRefresh {
	
	//Reload table
	[self loadContent];
//  [self reloadDataAndDataSources];
	[self.tableView reloadData];
  //Stop refreshing
  [self.refreshControl endRefreshing];
	
	
	
}


- (BOOL)isPatchFileAtURL:(NSURL*)file {
	
	
	
	NSString* ext = [file.pathExtension lowercaseString];
	
	NSArray *supportedExtensions = @[
	@"ups",
	@"ips",
	@"ppf",
	@"bps",
	@"rup",
	];
	if ([supportedExtensions containsObject:ext]) return YES;
	
	
	/*if([lowerPath hasSuffix:@".ups"]){
		return TRUE;
	}
	else if ([lowerPath hasSuffix:@".ips"]){
		return TRUE;
	}
	else if([lowerPath hasSuffix:@".ppf"]){
		return TRUE;
	}
	else if([lowerPath hasSuffix:@".bps"]){
		return TRUE;
	}
	else if([lowerPath hasSuffix:@".rup"]){
		return TRUE;
	}*/
	
	return NO;
	
}


- (void)unselectRow
{
  NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
  if(selectedIndexPath)
  {
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
  }
}

/*
- (void)alertWithTitle:(NSString *)tot message:(NSString *)mes 
{
	
	
	
	UIAlertView *allert = [[UIAlertView alloc] initWithTitle:tot message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[allert show];
	
}*/

- (NSString *)fileSizeAtFullPath:(NSURL *)fullPath {
	
	 
	
	NSError *error;
	NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:[fullPath path] error:&error]; 
	
	if (error) {
		[kora alertWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
		return @"error";
	}
	
	return [NSByteCountFormatter stringFromByteCount:[fileAttr fileSize] countStyle:NSByteCountFormatterCountStyleFile];
	
}

/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/

@end
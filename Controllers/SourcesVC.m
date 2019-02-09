#import "SourcesVC.h"
#import "../shared.h"
#import <LSApplicationWorkspace.h>
//#import <LSApplicationProxy.h>
#import "FMController.h"







#define kCell @"spCell"

@interface SourcesVC ()

@property (nonatomic, strong) NSArray<LSApplicationProxy*> *uApps;
@property (nonatomic, strong) NSArray<NSURL*> *spDirs;
@end



@implementation SourcesVC {
Avatar *kora;
}

@synthesize uApps, spDirs;



- (id)init {
	
	self = [super init];
	if (!self) return nil;
	
	
	return self;
}

- (void) dealloc
{
	
}




- (void)loadView {
	
	[super loadView];
	
	self.view.backgroundColor = kBgcolor;
	kora = [Avatar shared];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
	
	[self navBarMagic];
	
	
	
	
		/*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{*/
		// Do something...
		
		[self loadContent];
		
		/*dispatch_async(dispatch_get_main_queue(), ^{
		
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	});
});*/
	
}

- (void)viewDidAppear:(BOOL)anim {
	
	[super viewDidAppear:anim];
	
	//[self reloadFavs];
}

- (void)loadContent {
	
	spDirs = @[[NSURL URLWithString:@"/var/mobile"]];
	
	
	LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
	if (workspace) {
		uApps = [workspace applicationsOfType:0];
		[self sortArrayAscending:YES];
	}else {
		[kora alertWithTitle:@"Error" message:@"Failed to get user apps"];
	}
	
	
	
}

- (void)sortArrayAscending:(BOOL)flag {
	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"localizedName" ascending:flag selector:@selector(localizedCaseInsensitiveCompare:)];
	self.uApps = [uApps sortedArrayUsingDescriptors:@[sortDescriptor]];
	
	
}



#pragma mark Tableview delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) {
		return spDirs.count;
	}else {
		return uApps.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCell];
	}
	
	if (indexPath.section == 1) {
		cell.textLabel.textColor = Red;
	}else {
		cell.textLabel.textColor = Blue;
	}
	
	
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)ip { 
	
	if (ip.section == 0) {
		
		
		cell.textLabel.text = spDirs[ip.row].path.lastPathComponent;
		cell.detailTextLabel.text = spDirs[ip.row].path;
		
	}else if (ip.section == 1) {
		
		
		cell.textLabel.text = uApps[ip.row].localizedName;
		
		cell.detailTextLabel.text = uApps[ip.row].bundleIdentifier;
		
	}
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)ip {
	
	if (ip.section == 0) {
		NSURL *path = spDirs[ip.row];
		
		[self.navigationController pushViewController:[[FMController alloc] initWithPath:path] animated:YES];
		
	}else {
		
		
		NSURL *path = [uApps[ip.row].dataContainerURL URLByAppendingPathComponent:@"Documents"];
		
		
		[self.navigationController pushViewController:[[FMController alloc] initWithPath:path andBundleID:uApps[ip.row].bundleIdentifier] animated:YES];
		
	}
	
	
	
	
	//andBundleID
}







#pragma mark custom functions


- (void)navBarMagic {
	
	self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.translucent = NO;
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	
}


@end


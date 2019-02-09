#import "BookmarksVC.h"
#import "../shared.h"
#import "FMController.h"







#define kCell @"bCell"

@interface BookmarksVC ()

@property (nonatomic, strong) NSArray<Bookmark*> *bookmarks;
@end



@implementation BookmarksVC {
Avatar *kora;
}

@synthesize bookmarks;



- (id)init {
	
	self = [super init];
	if (!self) return nil;
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(reloadFavs) 
        name:kBookmarksReload
        object:nil];
        
	
	
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (void)loadView {
	
	[super loadView];
	
	self.title = @"Bookmarks";
	
	self.view.backgroundColor = kBgcolor;
	kora = [Avatar shared];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[self loadContent];
	
	[self navBarMagic];
}

- (void)viewDidAppear:(BOOL)anim {
	
	[super viewDidAppear:anim];
	
	[self reloadFavs];
}

- (void)loadContent {
	
	
	
	
	NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
	bookmarks = [[NSKeyedUnarchiver unarchiveObjectWithData:serialized] mutableCopy];
	
	if (!bookmarks) bookmarks = [@[] mutableCopy];
	
	
}

- (void)reloadFavs {
	
	
	
	NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
	bookmarks = [[NSKeyedUnarchiver unarchiveObjectWithData:serialized] mutableCopy];
	
	[self.tableView reloadData];
	
}



#pragma mark Tableview delegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCell];
	}
	
	
	cell.textLabel.textColor = Red;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)ip { 
	
	Bookmark *bm = bookmarks[ip.row];
	
	cell.textLabel.text = bm.name;
	
	if (bm.isApp){
	cell.detailTextLabel.text = bm.bundleID;
	}else {
		cell.detailTextLabel.text = bm.URL.path;
	}
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)ip {
	
	
	Bookmark *bm = bookmarks[ip.row];
	
	NSURL *path = bm.isApp == NO ? bm.URL : [bm getAppDataURL];
	
	
	[self.navigationController pushViewController:[[FMController alloc] initWithPath:path] animated:YES];
	
	
	
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



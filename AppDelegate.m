#import "AppDelegate.h"
#import "Controllers/Controllers.h"
#import "CC/Avatar.h"
#import "CC/Colours.h"


@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	
	
	
	UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
	
	UINavigationController *docsVC = [[UINavigationController alloc] initWithRootViewController:[[FMController alloc] initWithPath:[[Avatar shared] documentsDirectory]]];

	UINavigationController *prefsVC = [[UINavigationController alloc] initWithRootViewController:[[SettingsVC alloc] init]];
	
	UITabBarController *tabC = [[UITabBarController alloc] init];
	
	[tabC setViewControllers:@[mainVC, docsVC, prefsVC]];

	tabC.tabBar.barTintColor = [UIColor colorWithRed:1 green:0.36 blue:0.36 alpha:1]; //Melrose
	tabC.tabBar.translucent = NO;
	tabC.tabBar.tintColor = [UIColor whiteColor];
	tabC.tabBar.unselectedItemTintColor = [UIColor colorWithRed:0 green:0.1 blue:0.174 alpha:1];



	mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Patcher" image:[UIImage imageNamed:@"icons/patch.png"] tag:200];
	docsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Documents" image:[UIImage imageNamed:@"icons/FilesTab-Unselected.png"] selectedImage:[UIImage imageNamed:@"icons/FilesTab-Selected.png"]];
	prefsVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:420];
//UITabBarSystemItemMore

	window.rootViewController = tabC;
	[window makeKeyAndVisible];
}


// the code below is mostly copy/pasta from GBA4iOS source code 
// So thank you so much Riley Testut for your amazing work <3


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	if ([url isFileURL]) {
		
		[self moveFileAtPathToDocumentsDirectory:[url path]];
	}
	return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
	options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	
	if ([url isFileURL])
	{
		[self moveFileAtPathToDocumentsDirectory:[url path]];
	}
	/*else
	{
	return [self handleURLSchemeURL:url];
	}*/
	return YES;
}

- (void)moveFileAtPathToDocumentsDirectory:(NSString *)filepath
{
	NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	
	NSString *filename = [filepath lastPathComponent];

	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];

	NSString *indexDir = [documentsDirectory stringByAppendingPathComponent:@"inbox"];

	BOOL fileExists = NO;

	for (NSString *item in contents) {
		NSString *name = [item stringByDeletingPathExtension];
		NSString *newFilename = [filename stringByDeletingPathExtension];
		
		if ([name isEqualToString:newFilename]) {
			fileExists = YES;
			break;
		}//if
	}//for loop
	
	if (fileExists) {
		filename = [NSString stringWithFormat:@"%@-copy", filename];
	}
	
	[[NSFileManager defaultManager] moveItemAtPath:filepath toPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];

	if ([[NSFileManager defaultManager] contentsOfDirectoryAtPath:indexDir error:nil].count <= 0) {
		[[NSFileManager defaultManager] removeItemAtPath:indexDir error:nil];
	}

}




@end

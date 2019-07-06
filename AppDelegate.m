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
	
	
	//UINavigationController *bookmarksVC = [[UINavigationController alloc] initWithRootViewController:[[BookmarksVC alloc] init]];
	
	
	
	//UINavigationController *appsVC = [[UINavigationController alloc] initWithRootViewController:[[SourcesVC alloc] init]];
	
	
	UITabBarController *tabC = [[UITabBarController alloc] init];
	[tabC setViewControllers:@[mainVC, docsVC /*, bookmarksVC, appsVC */ ]];
	
	mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Patcher" image:[UIImage imageNamed:@"icons/patch.png"] tag:200];
	docsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Documents" image:[UIImage imageNamed:@"icons/docs.png"] tag:201];
	//appsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Others" image:[UIImage imageNamed:@"icons/others.png"] tag:203];
	//bookmarksVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:204];
	
	window.rootViewController = tabC;
	[window makeKeyAndVisible];
}




@end
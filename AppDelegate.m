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
	
	UITabBarController *tabC = [[UITabBarController alloc] init];
	[tabC setViewControllers:@[mainVC, docsVC]];
	
	mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Patcher" image:[UIImage imageNamed:@"icons/patch.png"] tag:200];
	docsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Documents" image:[UIImage imageNamed:@"icons/docs.png"] tag:201];
	
	window.rootViewController = tabC;
	[window makeKeyAndVisible];
}


// the code below is mostly copy/pasta from GBA4iOS source code 
// So thank you so much Riley Testut for your amazing work <3


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	if ([url isFileURL]) {
		
		[self copyFileAtPathToDocumentsDirectory:[url path]];
	}
	return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
	options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
	
	if ([url isFileURL])
	{
		[self copyFileAtPathToDocumentsDirectory:[url path]];
	}
	/*else
	{
	return [self handleURLSchemeURL:url];
	}*/
	return YES;
}

- (void)copyFileAtPathToDocumentsDirectory:(NSString *)filepath
{
	NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	
	NSString *filename = [filepath lastPathComponent];

	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];

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
}




@end

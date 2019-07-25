// Util.h 
// Made by Wh0ba

#ifndef Util_h
#define Util_h




#import "CC/Avatar.h"

#import "CC/Colours.h"
#import "CC/MBProgressHUD.h"
#import "CC/Toast/UIView+Toast.h"





#define kFMReloadContent @“FM.ReloadContent”

#define kBgcolor [UIColor whiteColor]
#define kFgcolor [UIColor blackColor]

#define kSetFileNotification @"iPatchSetFileURL"
#define kBookmarksReload @"kFavsReload"
///controllers


#define urlToString(xx) [[[xx absoluteString] lastPathComponent] stringByRemovingPercentEncoding]



#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)



#define SCR [UIScreen mainScreen].bounds.size
#define SCRB [UIScreen mainScreen].bounds

#define CLS cell.frame.size
#define FS frame.size
#define SFS self.frame.size
#define SFO self.frame.origin
#define FO frame.origin
#define SVFS self.view.frame.size
#define SVFO self.view.frame.origin
#define SV self.view

//#define OrgGlow [UIColor colorFromHexString:@"#FF4400"]
#define SFOS(x) [UIFont systemFontOfSize:x]
#define defWid (SVFS.width - 40)
#define ALblWid(x) [x.text sizeWithFont:x.font].width


#pragma mark colors

#define Black [UIColor blackColor]
#define Red [UIColor redColor]
#define Green [UIColor greenColor]
#define Blue [UIColor blueColor]
#define White [UIColor whiteColor]
#define Clear [UIColor clearColor]
#define Cyan [UIColor cyanColor]





#endif

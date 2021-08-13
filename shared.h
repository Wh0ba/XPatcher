// Util.h 
// Made by Wh0ba 2017

#ifndef Util_h
#define Util_h




#import "CC/Avatar.h"

#import "CC/Colours.h"
#import "CC/MBProgressHUD.h"
#import "CC/Toast/UIView+Toast.h"





#define kBgcolor [UIColor whiteColor]
#define kFgcolor [UIColor blackColor]



#define kDefPatchColor [UIColor colorWithRed:0.7 green:0 blue:1 alpha:1]

#define kDefROMColor [UIColor colorWithRed:0.34 green:0.54 blue:0.76 alpha:1]


#define kSetFileNotification @"iPatchSetFileURL"
#define kBookmarksReload @"kFavsReload"
#define kPatchModeChangedNotification @"kPMCN"
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







#endif

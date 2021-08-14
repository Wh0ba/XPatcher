#import "ViewController.h"
#import "../CC/txtField.h"
#import "../MC/adapters/adapters.h"
#import "../defs.h"
#import "../shared.h"
#define kDefH 50
#define kFieldY 40
#define sumPosOf(x) ((x.FO.y + x.FS.height) + 20)
#define viewTag(x) [SV viewWithTag:x]

typedef enum PatchTypes {
    UNKNOWNPAT,
    UPSPAT,
    XDELTAPAT,
    IPSPAT,
    PPFPAT,
    BSDIFFPAT,
    BPSPAT,
    BPSDELTA,
    RUPPAT
} PatchFormat;

PatchFormat currentFormat;
PatchFormat creationFormat;

@interface ViewController ()

@property(nonatomic, strong) UIButton *applyBtn;
@property(nonatomic, strong) UIButton *patchTypeBtn;
@property(nonatomic, strong) UILabel *statusLabel;

@end

@implementation ViewController {
    Avatar *Korra;
}
@synthesize resultPathField, romPathField, patchPathField, applyBtn,
    statusLabel, patchTypeBtn;

- (id)init {

    self = [super init];
    if (!self)
        return nil;

    Korra = [Avatar shared];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setFileURL:)
                                                 name:kSetFileNotification
                                               object:nil];
    Korra.isApplyPatchMode = YES;
    creationFormat = IPSPAT;
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [super loadView];

    self.view.backgroundColor = kBgcolor;
    [[UIApplication sharedApplication] keyWindow].tintColor = kMelroseColor;

    self.title = @"XPatcher";

    [self navBarMagic];
    [self setupNavButtons];

    [self loadFields];
    [self loadButtons];
    [self applyTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadLabels];
    romPathField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    patchPathField.inputView = [[UIView alloc] initWithFrame:CGRectZero];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyTheme)
                                                 name:kChangeThemeNotification
                                               object:nil];
}

#pragma mark - UI Methods

- (void)cleanFields {
    romPathField.text = nil;
    romPathField.fileURL = nil;
    patchPathField.text = nil;
    patchPathField.fileURL = nil;
    resultPathField.text = nil;
    resultPathField.fileURL = nil;
}

- (void)navBarMagic {

    // self.navigationController.navigationBar.barTintColor = kMelroseColor;
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationController.navigationBar.translucent = NO;

    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor]
    }];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - Bar Buttons
- (void)setupNavButtons {

    UIBarButtonItem *clearBarButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(cleanFields)];
    self.navigationItem.rightBarButtonItem = clearBarButton;

    UIBarButtonItem *modeSwitchBarButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Mode↹"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(showChangeModeAlert)];
    self.navigationItem.leftBarButtonItem = modeSwitchBarButton;
}

- (void)showChangeModeAlert {

    UIAlertController *actionSheet = [UIAlertController
        alertControllerWithTitle:@"Change Patching Mode"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction 
										actionWithTitle:@"Cancel"
                                        style:UIAlertActionStyleCancel
                                       	handler:^(UIAlertAction *action) { [self dismissViewControllerAnimated:YES completion:nil]; }]];

	[actionSheet addAction:
		[UIAlertAction 
			actionWithTitle:@"Apply Patch" 
			style:UIAlertActionStyleDefault 
			handler:^(UIAlertAction *action) { 
				[self changePatchingMode:YES]; 
			}]];
	[actionSheet addAction:
		[UIAlertAction 
			actionWithTitle:@"Create Patch" 
			style:UIAlertActionStyleDefault 
			handler:^(UIAlertAction *action) {
				[self changePatchingMode:NO];
			}]];
    
	//This tells the action sheet to popUp from the "Mode↹" bar button (looks dope and clear),and if not provided it will CRASH on iPads
    actionSheet.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
	[self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changePatchingMode:(BOOL)applyMode {

    [self cleanFields];
    Korra.isApplyPatchMode = applyMode;
    patchTypeBtn.hidden = applyMode;
	if (applyMode) {
        romPathField.placeholder = @"ROM file";
        patchPathField.placeholder = @"Patch file";
        [applyBtn setTitle:@"Apply" forState:UIControlStateNormal];
    }
    else {
        romPathField.placeholder = @"Original ROM";
        patchPathField.placeholder = @"Modified ROM";
        [applyBtn setTitle:@"Create" forState:UIControlStateNormal];
    }
    [self applyTheme];
}

- (void)showChangePatchTypeAlert {

    UIAlertController *actionSheet = [UIAlertController
        alertControllerWithTitle:@"Choose Patch Type to create"
                        message:@"BPS and IPS are highly recommended"
                        preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction
                               actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action) {
                                         [self dismissViewControllerAnimated:YES
                                                                  completion:^{
                                                                  }];
                                       }]];

    
    [actionSheet addAction: [self alertActionWithPatchFormat:IPSPAT]];
    [actionSheet addAction: [self alertActionWithPatchFormat:BPSPAT]];
    [actionSheet addAction: [self alertActionWithPatchFormat:PPFPAT]];
    [actionSheet addAction: [self alertActionWithPatchFormat:RUPPAT]];
    [actionSheet addAction: [self alertActionWithPatchFormat:UPSPAT]];
    [actionSheet addAction: [self alertActionWithPatchFormat:XDELTAPAT]];
    

    //These two lines make the action sheet popUp from the Patch Type button position (nice & clean)
	//Otherwise it will CRASH on iPads (with missing position info error)
    actionSheet.popoverPresentationController.sourceView = self.view;
	actionSheet.popoverPresentationController.sourceRect = patchTypeBtn.frame;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (UIAlertAction*)alertActionWithPatchFormat:(PatchFormat)format {
        NSString* patchTypeName = [[self getPatchExtensionForFormat:format] uppercaseString];
        NSString *title = patchTypeName;
        if (creationFormat == format) {
            title = [title stringByAppendingString:@"✅"];
        }
    UIAlertAction* action = [UIAlertAction 
				actionWithTitle:title
				style:UIAlertActionStyleDefault 
				handler:^(UIAlertAction *action) {
					creationFormat = format;
                    [patchTypeBtn setTitle:[@"Patch Type: " stringByAppendingString:patchTypeName] forState:UIControlStateNormal];
                    [self updateResultExtension];
				}];

    return action;
}

- (void)updateResultExtension{
    NSURL *url = resultPathField.fileURL;
    if (url){
        NSString *newStr = [url.path stringByDeletingPathExtension];
		newStr = [newStr stringByAppendingPathExtension:[self getPatchExtensionForFormat:creationFormat]];
        NSURL *resultURL = [NSURL fileURLWithPath:newStr isDirectory:NO];
        resultPathField.fileURL = resultURL;
        resultPathField.text = [resultURL lastPathComponent];
    }
}

- (void)changeTheme {
    if (Korra.currentTheme == XPThemeDark) {
        [Korra setTheme:XPThemeLight];
    } else if (Korra.currentTheme == XPThemeLight) {
        [Korra setTheme:XPThemeDark];
    }
}
#pragma mark loading UI

- (void)loadFields {

    romPathField = [[txtField alloc]
        initWithFrame:CGRectMake(20, kFieldY, (SCR.width - 40), kDefH)];
    romPathField.placeholder = @"ROM file";
    romPathField.tag = 1;
    romPathField.userInteractionEnabled = false;
    romPathField.clipsToBounds = true;
    romPathField.textAlignment = NSTextAlignmentCenter;
    romPathField.delegate = self;

    patchPathField =
        [[txtField alloc] initWithFrame:CGRectMake(20, (sumPosOf(romPathField)), (SCR.width - 40), kDefH)];
    patchPathField.tag = 2;
    patchPathField.placeholder = @"Patch file";
    patchPathField.delegate = self;
    patchPathField.userInteractionEnabled = false;
    patchPathField.clipsToBounds = true;
    patchPathField.textAlignment = NSTextAlignmentCenter;

    resultPathField = [[txtField alloc]
        initWithFrame:CGRectMake(20, (sumPosOf(patchPathField)),(SCR.width - 40), kDefH)];

    resultPathField.placeholder = @"Type result file name";
    resultPathField.delegate = self;
    resultPathField.tag = 5;
    resultPathField.layer.borderWidth = 2;
    resultPathField.clipsToBounds = true;

    [SV addSubview:resultPathField];
    [SV addSubview:romPathField];
    [SV addSubview:patchPathField];

    resultPathField.translatesAutoresizingMaskIntoConstraints = NO;
    romPathField.translatesAutoresizingMaskIntoConstraints = NO;
    patchPathField.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint constraintWithItem:romPathField
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.topLayoutGuide
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:romPathField
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeHeight
                                multiplier:0
                                constant:kDefH]
        .active = true;

    [NSLayoutConstraint constraintWithItem:romPathField
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:romPathField
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:-20]
        .active = true;

    /////////////////////////

    [NSLayoutConstraint constraintWithItem:patchPathField
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:romPathField
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:5]
        .active = true;

    [NSLayoutConstraint constraintWithItem:patchPathField
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeHeight
                                multiplier:0
                                constant:kDefH]
        .active = true;

    [NSLayoutConstraint constraintWithItem:patchPathField
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:patchPathField
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:-20]
        .active = true;

    //////////)/)/)/)/)/((//))//))/)/

    [NSLayoutConstraint constraintWithItem:resultPathField
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:patchPathField
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:resultPathField
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeHeight
                                multiplier:0
                                constant:kDefH]
        .active = true;

    [NSLayoutConstraint constraintWithItem:resultPathField
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:resultPathField
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:-20]
        .active = true;
}

- (void)loadButtons {

    applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn addTarget:self
                action:@selector(handleApplyCreateButtonAction)
                forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitle:@"Apply" forState:UIControlStateNormal];
    [applyBtn setTitleColor:kBgcolor forState:UIControlStateNormal];
    applyBtn.backgroundColor = kMelroseColor;
    applyBtn.layer.cornerRadius = 7;
    applyBtn.clipsToBounds = YES;
    applyBtn.layer.borderWidth = 2;
    applyBtn.layer.borderColor = kMelroseColor.CGColor;
    applyBtn.frame =
        CGRectMake(20, (sumPosOf(viewTag(5)) + 30), (SCR.width - 40), 40);

    [SV addSubview:applyBtn];

    applyBtn.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint constraintWithItem:applyBtn
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:resultPathField
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:30]
        .active = true;

    [NSLayoutConstraint constraintWithItem:applyBtn
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeHeight
                                multiplier:0
                                constant:40]
        .active = true;

    [NSLayoutConstraint constraintWithItem:applyBtn
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:applyBtn
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:-20]
        .active = true;

    //--------------------Patch Type Button -----------------------

    patchTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [patchTypeBtn addTarget:self
                    action:@selector(showChangePatchTypeAlert)
                    forControlEvents:UIControlEventTouchUpInside];

    [patchTypeBtn setTitle:@"Patch Type: IPS" forState:UIControlStateNormal];
    [patchTypeBtn setTitleColor:kBgcolor forState:UIControlStateNormal];
    patchTypeBtn.backgroundColor = kMelroseColor;
    patchTypeBtn.layer.cornerRadius = 7;
    patchTypeBtn.clipsToBounds = YES;
    patchTypeBtn.layer.borderWidth = 2;
    patchTypeBtn.layer.borderColor = kMelroseColor.CGColor;
    patchTypeBtn.frame =
        CGRectMake(20, (sumPosOf(viewTag(5)) + 30), (SCR.width - 40), 40);
    [SV addSubview:patchTypeBtn];

    patchTypeBtn.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint constraintWithItem:patchTypeBtn
                                attribute:NSLayoutAttributeTop
                                relatedBy:NSLayoutRelationEqual
                                toItem:applyBtn
                                attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                constant:30]
        .active = true;

    [NSLayoutConstraint constraintWithItem:patchTypeBtn
                                attribute:NSLayoutAttributeHeight
                                relatedBy:NSLayoutRelationEqual
                                toItem:nil
                                attribute:NSLayoutAttributeHeight
                                multiplier:0
                                constant:40]
        .active = true;

[NSLayoutConstraint constraintWithItem:patchTypeBtn
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                constant:20]
        .active = true;

    [NSLayoutConstraint constraintWithItem:patchTypeBtn
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                constant:-20]
        .active = true;
    patchTypeBtn.hidden = Korra.isApplyPatchMode;
}

- (void)applyTheme {

    if (Korra.currentTheme == XPThemeLight) {

        self.view.backgroundColor = White;
        applyBtn.backgroundColor = kMelroseColor;
        patchTypeBtn.backgroundColor = kMelroseColor;
        [applyBtn setTitleColor:White forState:UIControlStateNormal];
        [patchTypeBtn setTitleColor:White forState:UIControlStateNormal];

        [romPathField applyTheme:XPThemeLight];
        [patchPathField applyTheme:XPThemeLight];
        [resultPathField applyTheme:XPThemeLight];

        self.navigationController.navigationBar.barTintColor = kMelroseColor;
        self.navigationController.navigationBar.tintColor = White;

        if (self.tabBarController.tabBar) {
            self.tabBarController.tabBar.barTintColor = kMelroseColor;
            self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
            self.tabBarController.tabBar.unselectedItemTintColor =
                [UIColor colorWithWhite:0.4 alpha:1];
        }
    } else if (Korra.currentTheme == XPThemeDark) {

        UIColor *blackColor = [UIColor blackColor];

        self.view.backgroundColor = blackColor;
        applyBtn.backgroundColor = blackColor;
        patchTypeBtn.backgroundColor = blackColor;
        [applyBtn setTitleColor:kMelroseColor forState:UIControlStateNormal];
        [patchTypeBtn setTitleColor:kMelroseColor forState:UIControlStateNormal];

        [romPathField applyTheme:XPThemeDark];
        [patchPathField applyTheme:XPThemeDark];
        [resultPathField applyTheme:XPThemeDark];

        self.navigationController.navigationBar.barTintColor = blackColor;
        self.navigationController.navigationBar.tintColor = kMelroseColor;

        if (self.tabBarController.tabBar) {
            self.tabBarController.tabBar.barTintColor = blackColor;
            self.tabBarController.tabBar.tintColor = kMelroseColor;
            self.tabBarController.tabBar.unselectedItemTintColor =
                [UIColor colorWithWhite:0.7 alpha:1];
        }
    }
}


#pragma mark - TextFields

- (BOOL)textField:(UITextField *)tf
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    if (tf == romPathField | tf == patchPathField) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(txtField *)tF {

    NSURL *newURL = nil;

    if (tF.tag == 5) {
        if ([tF.text isEqualToString:@""] || !tF.text) {
            newURL = [NSURL
                fileURLWithPath:[[Korra documentsDirectory].path
                                    stringByAppendingPathComponent:@"tmp.rom"]
                    isDirectory:NO];
        } else {
            if (tF.fileURL) {
				//gets the file url which is passed from FMController when selecting a rom then it changes the file name with the new text and checks if the extensions match
                NSString *ex = [tF.fileURL.path pathExtension];
                NSString *newStr =
                    [tF.fileURL.path stringByDeletingLastPathComponent];
                newStr = [newStr stringByAppendingPathComponent:tF.text];
                if (![newStr.pathExtension isEqualToString:ex]) {
                    newStr = [newStr stringByAppendingPathExtension:ex];
                }
                newURL = [NSURL fileURLWithPath:newStr isDirectory:NO];
            } else {
				newURL = [NSURL
                fileURLWithPath:[[Korra documentsDirectory].path
                                    stringByAppendingPathComponent:tF.text]
                    isDirectory:NO];
			}
        }     
        tF.fileURL = newURL;
    }

    [tF resignFirstResponder];

    return YES;
}

- (void)setFileURL:(NSNotification *)noti {

    NSDictionary *info = noti.userInfo;

    int tag = [info[@"tag"] intValue];
    NSURL *url = info[@"fileURL"];
    if (tag == 2) {
        currentFormat = [self detectPatchFormat:url.path];

    }else {

        NSString *ex = [url.path pathExtension];
        NSString *newStr = [url.path stringByDeletingPathExtension];
		if (Korra.isApplyPatchMode){
			newStr = [newStr stringByAppendingString:@"[Patched]"];
			newStr = [newStr stringByAppendingPathExtension:ex];
		}else {
			newStr = [newStr stringByAppendingPathExtension:[self getPatchExtensionForFormat:creationFormat]];
		}
        if(tag == 3) tag = 2;//set it to the second text field tag so the url and text go to the text field for the modified ROM

        if ([newStr rangeOfString:@"/var/mobile/Containers/"
                options:NSCaseInsensitiveSearch]
                .location != NSNotFound) {
            NSString *fileName = newStr.lastPathComponent;
            newStr = [Korra.documentsDirectory.path
                stringByAppendingPathComponent:fileName];
        }

        NSURL *resultURL = [NSURL fileURLWithPath:newStr isDirectory:NO];
        resultPathField.fileURL = resultURL;
        resultPathField.text = [resultURL lastPathComponent];
    }
    ((txtField *)viewTag(tag)).fileURL = url;
    ((txtField *)viewTag(tag)).text = [url lastPathComponent];
}

#pragma mark - Patching

- (void)handleApplyCreateButtonAction {
	if (Korra.isApplyPatchMode) {
		
            [self applyPat];
        
	}else {
            [self startCreatePatch];
	}
}


- (NSString *)getPatchExtensionForFormat:(PatchFormat)format {
    if (format == UPSPAT) {
        return @"ups";
    } else if (format == IPSPAT) {
        return @"ips";
    } else if (format == PPFPAT) {
        return @"ppf";
    } else if (format == BPSPAT) {
        return @"bps";
    } else if (format == RUPPAT) {
        return @"rup";
    } else if (format == XDELTAPAT) {
        return @"xdelta";
    } else {
        return @"dat";
    }
}

- (PatchFormat)detectPatchFormat:(NSString *)patchPath {

    NSString *lowerPath = [patchPath lowercaseString];
    if ([lowerPath hasSuffix:@".ups"]) {
        return UPSPAT;
    } else if ([lowerPath hasSuffix:@".ips"]) {
        return IPSPAT;
    } else if ([lowerPath hasSuffix:@".ppf"]) {
        return PPFPAT;
    } else if ([lowerPath hasSuffix:@".bps"]) {
        return BPSPAT;
    } else if ([lowerPath hasSuffix:@".rup"]) {
        return RUPPAT;
    } else if ([lowerPath hasSuffix:@".dat"] || [lowerPath hasSuffix:@"xdelta"] || [lowerPath hasSuffix:@"delta"]) {
        return XDELTAPAT;
    }
    return UNKNOWNPAT;
}

- (MPPatchResult *)ApplyPatch:(NSString *)patchPath
                             :(NSString *)sourceFile
                             :(NSString *)destFile {
    MPPatchResult *retval = nil;
    if (currentFormat == UPSPAT) {
        retval = [UPSAdapter ApplyPatch:patchPath
                            toFile:sourceFile
                            andCreate:destFile];
    } else if (currentFormat == IPSPAT) {
        retval = [IPSAdapter ApplyPatch:patchPath
                            toFile:sourceFile
                            andCreate:destFile];
    } else if (currentFormat == PPFPAT) {
        retval = [PPFAdapter ApplyPatch:patchPath
                            toFile:sourceFile
                            andCreate:destFile];
    } else if (currentFormat == BPSPAT) {
        retval = [BPSAdapter ApplyPatch:patchPath
                            toFile:sourceFile
                            andCreate:destFile];
    } else if (currentFormat == RUPPAT) {
        retval = [RUPAdapter ApplyPatch:patchPath
                            toFile:sourceFile
                            andCreate:destFile];
    } else if (currentFormat == XDELTAPAT) {
        retval = [XDeltaAdapter ApplyPatch:patchPath
                                toFile:sourceFile
                                andCreate:destFile];
    }
    return retval;
}

- (void)applyPat {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *romPath = [romPathField fileURL].path;
    NSString *outputPath = [resultPathField fileURL].path;
    NSString *patchPath = [patchPathField fileURL].path;

    if ([fileManager fileExistsAtPath:patchPath]) {
        if ([romPath length] > 0 && [outputPath length] > 0 &&
            [patchPath length] > 0) {

            MPPatchResult *errMsg =
                [self ApplyPatch:patchPath:romPath:outputPath];

            if (errMsg == nil) {
                [Korra alertWithTitle:@"Done"
                            message:@"The Patch Has Been Applied"];
            } else if (errMsg.IsWarning) {
                [Korra alertWithTitle:@"Patching Finished With Warning"
                            message:errMsg.Message];
                errMsg = nil;
            } else {
                [Korra alertWithTitle:@"Patching Failed"
                            message:errMsg.Message];
            }
        }
    } else {
        [Korra alertWithTitle:@"Not ready yet"
                message:@"All of the files above must be valid before patching is possible."];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kFMReloadContent
                                                        object:nil
														userInfo:nil];
}



- (MPPatchResult *)createPatchFrom:(NSString *)modifiedROM
                             originalROM:(NSString *)sourceFile
                             output:(NSString *)destFile {
    MPPatchResult *retval = nil;
    if (creationFormat == UPSPAT) {
        retval = [UPSAdapter CreatePatch:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    } else if (creationFormat == IPSPAT) {
        retval = [IPSAdapter CreatePatch:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    } else if (creationFormat == PPFPAT) {
        retval = [PPFAdapter CreatePatch:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    } else if (creationFormat == BPSPAT) {
        retval = [BPSAdapter CreatePatchDelta:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    } else if (creationFormat == RUPPAT) {
        retval = [RUPAdapter CreatePatch:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    } else if (creationFormat == XDELTAPAT) {
        retval = [XDeltaAdapter CreatePatch:sourceFile
                                withMod:modifiedROM
								andCreate:destFile];
    }
    return retval;
}

- (void)startCreatePatch {

    
    NSString *romPath = [romPathField fileURL].path;
    NSString *outputPath = [resultPathField fileURL].path;
    NSString *modifiedROMPath = [patchPathField fileURL].path;

    if ([[NSFileManager defaultManager] fileExistsAtPath:modifiedROMPath]) {
        if ([romPath length] > 0 && [outputPath length] > 0 &&
            [modifiedROMPath length] > 0) {

            MPPatchResult *errMsg =
                [self createPatchFrom:modifiedROMPath
					originalROM:romPath
					output:outputPath];

            if (errMsg == nil) {
                [Korra alertWithTitle:@"Done"
									message:@"The Patch Has Been Created Successfully"];
            } else if (errMsg.IsWarning) {
                [Korra alertWithTitle:@"Creating The Patch Finished But With Warning"
									message:errMsg.Message];
                errMsg = nil;
            } else {
                [Korra alertWithTitle:@"Failed To Create the Patch"
									message:errMsg.Message];
            }
        }
    } else {
        [Korra alertWithTitle:@"Not ready yet"
				message:@"All of the files above must be valid before creating the patch."];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kFMReloadContent
                                                        object:nil
														userInfo:nil];
}


@end

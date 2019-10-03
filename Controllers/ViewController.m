#import "../shared.h"
#import "ViewController.h"
#import "../MC/adapters/adapters.h"
#import "../CC/txtField.h"
#define kDefH 50
#define kFieldY 40
#define sumPosOf(x) ((x.FO.y + x.FS.height) + 20)
#define viewTag(x) [SV viewWithTag:x]



typedef enum PatchTypes{
	UNKNOWNPAT, UPSPAT, XDELTAPAT, IPSPAT, PPFPAT, BSDIFFPAT, BPSPAT, BPSDELTA, RUPPAT
} PatchFormat;


PatchFormat currentFormat;
@interface ViewController()

@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UILabel *statusLabel;

@end



@implementation ViewController {
	Avatar *Aang;
}
@synthesize resultPathField, romPathField, patchPathField, applyBtn ,statusLabel;


- (id)init {
	
	self = [super init];
	if (!self) return nil;
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(setFileURL:) 
        name:kSetFileNotification
        object:nil];
	Aang = [Avatar shared];
	
	
	return self;
}


- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
	[super loadView];
	
	
	self.view.backgroundColor = kBgcolor;
	[[UIApplication sharedApplication] keyWindow].tintColor = kMelroseColor;
	
	self.title = @"XPatcher";
	
	[self navBarMagic];
	
	
	
}

- (void)navBarMagic {
	
	self.navigationController.navigationBar.barTintColor = kMelroseColor;
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	self.navigationController.navigationBar.translucent = NO;
	
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

	[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
	
	UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(cleanFields)];
	self.navigationItem.rightBarButtonItem = clearButton;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self loadFields];
	[self loadButtons];
	//[self loadLabels];
	
	romPathField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
	patchPathField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
	
}

- (void)loadFields {
	
	romPathField = [[txtField alloc] initWithFrame:CGRectMake(20, kFieldY, (SCR.width - 40), kDefH)];
	romPathField.placeholder = @"Waiting for a ROM";
	romPathField.tag = 1;
	
	romPathField.delegate = self;
	
	patchPathField = [[txtField alloc] initWithFrame:CGRectMake(20, (sumPosOf(romPathField)), (SCR.width - 40), kDefH)]; 
	patchPathField.tag = 2;
	patchPathField.placeholder = @"Waiting for a Patch file";
	patchPathField.delegate = self;
	
	resultPathField = [[txtField alloc] initWithFrame:CGRectMake(20, (sumPosOf(patchPathField)), (SCR.width - 40), kDefH)];
	
	resultPathField.placeholder = @"Result File";
	resultPathField.delegate = self;
	resultPathField.tag = 5;
	
	
	[SV addSubview:resultPathField];
	[SV addSubview:romPathField];
	[SV addSubview:patchPathField]; 
	
	resultPathField.translatesAutoresizingMaskIntoConstraints = NO;
	romPathField.translatesAutoresizingMaskIntoConstraints = NO;
	patchPathField.translatesAutoresizingMaskIntoConstraints = NO;
	
	
	//NSLayoutConstraint* TopFieldCn = 
	[NSLayoutConstraint constraintWithItem:romPathField
		attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
		toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom
		multiplier:1.0 constant:20].active = true;
		
	[NSLayoutConstraint constraintWithItem:romPathField
	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
	toItem:nil attribute:NSLayoutAttributeHeight
 	multiplier:0 constant:kDefH].active = true;
	
	[NSLayoutConstraint constraintWithItem:romPathField
	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeLeading
	multiplier:1.0 constant:20].active = true;
	
	[NSLayoutConstraint constraintWithItem:romPathField
	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeTrailing
	multiplier:1.0 constant:-20].active = true;
		
		
		
		
		/////////////////////////
		
		
		
		
	[NSLayoutConstraint constraintWithItem:patchPathField
	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
	toItem:romPathField attribute:NSLayoutAttributeBottom
	multiplier:1.0 constant:20].active = true;
	
	[NSLayoutConstraint constraintWithItem:patchPathField
	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
	toItem:nil attribute:NSLayoutAttributeHeight
 	multiplier:0 constant:kDefH].active = true;
	
	[NSLayoutConstraint constraintWithItem:patchPathField
	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeLeading
	multiplier:1.0 constant:20].active = true;
	
	[NSLayoutConstraint constraintWithItem:patchPathField
	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeTrailing
	multiplier:1.0 constant:-20].active = true;
		
		
		//////////)/)/)/)/)/((//))//))/)/
		
		[NSLayoutConstraint constraintWithItem:resultPathField
		attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
		toItem:patchPathField attribute:NSLayoutAttributeBottom
		multiplier:1.0 constant:20].active = true;
		
		[NSLayoutConstraint constraintWithItem:resultPathField
	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
	toItem:nil attribute:NSLayoutAttributeHeight
 	multiplier:0 constant:kDefH].active = true;
	
	[NSLayoutConstraint constraintWithItem:resultPathField
	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeLeading
	multiplier:1.0 constant:20].active = true;
	
	[NSLayoutConstraint constraintWithItem:resultPathField
	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeTrailing
	multiplier:1.0 constant:-20].active = true;
	
		
		
		//resultPathField
	
	//[self.rootViewController.view addConstraint:TopFieldCn];
	
}

- (void)loadButtons {
	
	
	applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[applyBtn addTarget:self action:@selector(applyPat) forControlEvents:UIControlEventTouchUpInside];
	[applyBtn setTitle:@"Apply" forState:UIControlStateNormal];
	[applyBtn setTitleColor:kBgcolor forState:UIControlStateNormal];
	applyBtn.backgroundColor = kMelroseColor;
	applyBtn.layer.cornerRadius = 7;
	applyBtn.clipsToBounds = YES;
	applyBtn.frame = CGRectMake(20, (sumPosOf(viewTag(5)) + 30), (SCR.width - 40), 40);
	
	[SV addSubview:applyBtn];
	
	applyBtn.translatesAutoresizingMaskIntoConstraints = NO;
	
	
	[NSLayoutConstraint constraintWithItem:applyBtn
	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
	toItem:resultPathField attribute:NSLayoutAttributeBottom
	multiplier:1.0 constant:30].active = true;
	
	[NSLayoutConstraint constraintWithItem:applyBtn
	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
	toItem:nil attribute:NSLayoutAttributeHeight
 	multiplier:0 constant:40].active = true;
	
	[NSLayoutConstraint constraintWithItem:applyBtn
	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeLeading
	multiplier:1.0 constant:20].active = true;
	
	[NSLayoutConstraint constraintWithItem:applyBtn
	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
	toItem:self.view attribute:NSLayoutAttributeTrailing
	multiplier:1.0 constant:-20].active = true;
	
}

- (void)loadLabels {
	
	statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCR.height - 300, (SCR.width - 20), 30)];
	statusLabel.text = @"Ready";
	statusLabel.textAlignment = NSTextAlignmentCenter;
	statusLabel.textColor = kFgcolor;
	[SV addSubview:statusLabel];
}

- (void)applyPat {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *romPath = [romPathField fileURL].path;
	NSString *outputPath = [resultPathField fileURL].path;
	NSString *patchPath = [patchPathField fileURL].path;
	
	if([fileManager fileExistsAtPath:patchPath]){
		if([romPath length] > 0 && [outputPath length] > 0 && [patchPath length] > 0){
			//statusLabel.text = @"Now patching...";
	
	MPPatchResult* errMsg = [self ApplyPatch:patchPath :romPath :outputPath];
		//[activityIndicator stopAnimating];
		//statusLabel.text = @"Ready";
		
		
		if(errMsg == nil){
			//[hud hideAnimated:YES];
			[Aang alertWithTitle:@"Done" message:@"The patch has been applied"];
			
		}
		else if(errMsg.IsWarning){
			//[hud hideAnimated:YES];
			
			[Aang alertWithTitle:@"Patching Finished With Warning" message:errMsg.Message];
			errMsg = nil;
		}else  {
			[Aang alertWithTitle:@"Patching Failed" message:errMsg.Message];
		}
		
		
		}
	}
	else{
		[Aang alertWithTitle:@"Not ready yet" message:@"All of the files above must be vaild before patching is possible."];
	}

//kFMReloadContent
	[[NSNotificationCenter defaultCenter] 
       postNotificationName:kFMReloadContent
        object:nil userInfo:nil];
}




#pragma mark -
#pragma mark TextField Delegate


- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (tf == romPathField | tf == patchPathField) {
		return NO;
	}
	else {
		return YES;
	}
}


- (BOOL)textFieldShouldReturn:(txtField *)tF {
	
	NSURL *newURL = nil;
	
	if (tF.tag == 5) {
		if ([tF.text isEqualToString:@""] || !tF.text){
		newURL = [NSURL fileURLWithPath:[[Aang documentsDirectory].path stringByAppendingPathComponent:tF.text] isDirectory:NO];
		}else {
			if (tF.fileURL) {
				
			
			NSString *ex = [tF.fileURL.path pathExtension];
		
		NSString *newStr = [tF.fileURL.path stringByDeletingLastPathComponent];
		
		newStr = [newStr stringByAppendingPathComponent:tF.text];
		if (![newStr.pathExtension isEqualToString:ex]) {
			newStr = [newStr stringByAppendingPathExtension:ex];
		}
		
		newURL = [NSURL fileURLWithPath:newStr isDirectory:NO];
			} //if tf.fileURL
		} //else
		tF.fileURL = newURL;
	}// if tag
	
	
	[tF resignFirstResponder];
	
	return YES;
	
	
}

- (void)setFileURL:(NSNotification*)noti {
	
	NSDictionary *info = noti.userInfo;
	
	int tag = [info[@"tag"] intValue]; 
	NSURL *url = info[@"fileURL"];
	if (tag == 2) {
		currentFormat = [self detectPatchFormat:url.path];
		
	}else if (tag == 1) {
		
		
		NSString *ex = [url.path pathExtension];
		
		NSString *newStr = [url.path stringByDeletingPathExtension];
		
		newStr = [newStr stringByAppendingString:@"[Patched]"];
		
		newStr = [newStr stringByAppendingPathExtension:ex];
		
		
		if ([newStr rangeOfString:@"/var/mobile/Containers/" options:NSCaseInsensitiveSearch].location != NSNotFound) {
		NSString *fileName = newStr.lastPathComponent;
		newStr = [Aang.documentsDirectory.path stringByAppendingPathComponent:fileName];
		
		
		}
		
		
		NSURL *resultURL = [NSURL fileURLWithPath:newStr isDirectory:NO];
		resultPathField.fileURL = resultURL;
		
		resultPathField.text = [resultURL lastPathComponent];
	}
	((txtField*)viewTag(tag)).fileURL = url;
	((txtField*)viewTag(tag)).text = [url lastPathComponent];
	
}

- (void)cleanFields {
	
	
	romPathField.text = nil;
	romPathField.fileURL = nil;
	patchPathField.text = nil;
	patchPathField.fileURL = nil;
	resultPathField.text = nil;
	resultPathField.fileURL = nil;
	
}


#pragma mark -
#pragma mark patching

- (PatchFormat)detectPatchFormat:(NSString*)patchPath{
	//I'm just going to look at the file extensions for now.
	//In the future, I might wish to actually look at the contents of the file.
    NSString* lowerPath = [patchPath lowercaseString];
	if([lowerPath hasSuffix:@".ups"]){
		return UPSPAT;
	}
	else if([lowerPath hasSuffix:@".ips"]){
		return IPSPAT;
	}
	else if([lowerPath hasSuffix:@".ppf"]){
		return PPFPAT;
	}
	else if([lowerPath hasSuffix:@".bps"]){
		return BPSPAT;
	}
	else if([lowerPath hasSuffix:@".rup"]){
		return RUPPAT;
	}else if([lowerPath hasSuffix:@".dat"] || [lowerPath hasSuffix:@"delta"]){
		return XDELTAPAT;
	}
	return UNKNOWNPAT;
}

- (MPPatchResult*)ApplyPatch:(NSString*)patchPath :(NSString*)sourceFile :(NSString*)destFile{
	MPPatchResult* retval = nil;
	if(currentFormat == UPSPAT){
		retval = [UPSAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
	}
	else if(currentFormat == IPSPAT){
		retval = [IPSAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
	}
	else if(currentFormat == PPFPAT){
		retval = [PPFAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
	}
    else if(currentFormat == BPSPAT){
        retval = [BPSAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
    }
    else if(currentFormat == RUPPAT){
        retval = [RUPAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
    }else if(currentFormat == XDELTAPAT){
        retval = [XDeltaAdapter ApplyPatch:patchPath toFile:sourceFile andCreate:destFile];
    }
	return retval;
}


/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
*/
@end

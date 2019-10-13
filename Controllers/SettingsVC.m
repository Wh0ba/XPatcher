#import "SettingsVC.h"

@implementation SettingsVC {
    Avatar *Aang;
}


- (void) loadView {
    [super loadView];
    Aang = [Avatar shared];


    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] 
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        target:self 
        action:@selector(dismissMe)];
    self.navigationItem.leftBarButtonItem = doneButton;
}
- (void) dismissMe {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = Aang.currentTheme == XPThemeDark ? Black : White;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


	
	
	    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];

        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"];
        }
        
	cell.textLabel.numberOfLines = 0;
	cell.contentView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];

    cell.textLabel.text = [NSString stringWithFormat:@"sec:%ld,row:%ld",indexPath.section, indexPath.row];//@"Dark mode";
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchview;
    switchview.tag = 69;
    [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];

	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath { 
	
	cell.textLabel.textColor = Aang.currentTheme == XPThemeDark ? White : Black;
}




- (void)updateSwitchAtIndexPath:(UISwitch*)aswitch{
	
    if (aswitch.tag == 69) {
        
    [Aang alertWithTitle:@"Dark mode" message:[NSString stringWithFormat:@"%@", aswitch.isOn ? @"ON" : @"OFF"]];
    }

}


@end
#import "ReminderViewController.h"

@implementation ReminderViewController

@synthesize TitleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Populate our view here.
    // Watch out for "NSNull"!

    id title = [_programInfo objectForKey:@"title"];
    TitleLabel.text =  (title != [NSNull null]) ? title : nil;
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onOKClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) setProgramInfo:(NSDictionary*)programInfo{
    // Can't populate the view here because the controls don't exist yet
    _programInfo = programInfo;
}

@end

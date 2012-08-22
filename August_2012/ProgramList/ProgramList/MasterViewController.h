#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UIPickerViewDelegate> {
    NSMutableArray * genres;
    NSDictionary *programInfo;
}

@property (strong, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) IBOutlet UISwitch *DetailSwitch;
@property (strong, nonatomic) IBOutlet UITextField *FilterText;

- (IBAction)onDetailSwitchChange:(id)sender;

-(void) inputAccessoryViewDidFinish; 

@end

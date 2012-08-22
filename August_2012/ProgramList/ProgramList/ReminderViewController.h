#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController  {
    NSDictionary *_programInfo;
}

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;

- (IBAction)onOKClick:(id)sender;

-(void) setProgramInfo:(NSDictionary*)programInfo;

@end

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    NSDictionary *_programInfo;
}

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *EpisodeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *GenreLabel;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionTextView;

-(void) setProgramInfo:(NSDictionary*)programInfo;

@end

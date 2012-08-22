#import "DetailViewController.h"

@implementation DetailViewController

@synthesize TitleLabel;
@synthesize EpisodeTitleLabel;
@synthesize GenreLabel;
@synthesize DescriptionTextView;


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Populate our view here.
    // Watch out for "NSNull"!

    id title = [_programInfo objectForKey:@"title"];
    TitleLabel.text =  (title != [NSNull null]) ? title : nil;

    id episodeTitle =  [_programInfo objectForKey:@"episodeTitle"];
    EpisodeTitleLabel.text = (episodeTitle != [NSNull null]) ? episodeTitle : nil;

    id genre = [_programInfo objectForKey:@"genre"];
    GenreLabel.text = (genre != [NSNull null]) ? genre : nil;

    id description = [_programInfo objectForKey:@"description"];
    DescriptionTextView.text = (description != [NSNull null]) ? description : nil;
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setEpisodeTitleLabel:nil];
    [self setGenreLabel:nil];
    [self setDescriptionTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) setProgramInfo:(NSDictionary*)programInfo {
    // Can't populate the view here because the controls don't exist yet
    _programInfo = programInfo;
}


@end

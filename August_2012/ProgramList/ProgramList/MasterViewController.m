#import "MasterViewController.h"
#import "ReminderViewController.h"

@implementation MasterViewController

@synthesize WebView;
@synthesize DetailSwitch;
@synthesize FilterText;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.WebView setDelegate:self];

    //NSURL *url = [[NSURL alloc] initWithString:@"http://somewebpath"];
    //NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    //[self.WebView loadRequest:urlRequest];

    // For the purposes or this demo, we'll load a local HTML file with the baseURL
    // set to the bundle path.
	
	NSString *baseUrlPath = [[NSBundle mainBundle] resourcePath];
    baseUrlPath = [baseUrlPath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	baseUrlPath = [baseUrlPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//", baseUrlPath]];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:
										@"index" ofType:@"html" inDirectory:nil];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [self.WebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:baseUrl];

    self.FilterText.delegate = self;
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setDetailSwitch:nil];
    [self setFilterText:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if([request.URL.path hasPrefix:@"/command/"])
    {
        // Grab the command from the path portion of the URL
        NSString *command = [request.URL.path stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:@""];
        NSLog(@"Command: %@", command);

        NSDictionary *commandArguments = nil;
        if(request.URL.query)
        {
            // Decode the URL encoded query string to get our JSON
            NSString *decodedQueryString = [request.URL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"Command Arguments: %@", decodedQueryString);


            // Convert the JSON to an object
            NSData *jsonData = [decodedQueryString dataUsingEncoding:NSUTF8StringEncoding];
            commandArguments = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        }

        if([command isEqualToString:@"details"]){
            programInfo = commandArguments;
            [self performSegueWithIdentifier:@"detailSegue" sender:self];
        }

        if([command isEqualToString:@"reminder"]){
            programInfo = commandArguments;
            [self performSegueWithIdentifier:@"reminderSegue" sender:self];
        }
        
        return false;
    }
    return true;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {

        [[segue destinationViewController] setProgramInfo:programInfo];
    }

    if ([[segue identifier] isEqualToString:@"reminderSegue"]) {

        [[segue destinationViewController] setProgramInfo:programInfo];
    }
}


- (IBAction)onDetailSwitchChange:(id)sender {
    
    NSString *scriptCommand = [NSString stringWithFormat:@"api.toggleDescriptions(%@);", DetailSwitch.isOn ? @"true" : @"false"];
    
    [self.WebView stringByEvaluatingJavaScriptFromString:scriptCommand];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    NSString *scriptCommand = @"api.getGenres(true);";
    
    NSString *scriptResult = [self.WebView stringByEvaluatingJavaScriptFromString:scriptCommand];
    
    if(scriptResult)
    {
        // Grab the command arguments from query portion of the URL 
        NSData *jsonData = [scriptResult dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *genreList = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        
        genres = [NSMutableArray arrayWithObject:@"All Programs"];
        [genres addObjectsFromArray:genreList];
    }

    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    self.FilterText.inputView = pickerView;
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,0, 320, 44)]; 
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inputAccessoryViewDidFinish)];
    [pickerToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    self.FilterText.inputAccessoryView = pickerToolbar;    
    
    for(int i = 0; i < genres.count; i++){
        if([[genres objectAtIndex:i] isEqualToString:FilterText.text])
        {
            [pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    return YES;
}


//animate the picker into view
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *newFilter = [self.FilterText.text isEqualToString:@"All Programs"] ? @"" : self.FilterText.text;
    
    NSString *scriptCommand = [NSString stringWithFormat:@"api.setGenreFilter('%@');", newFilter];
    
    
    NSString *result = [self.WebView stringByEvaluatingJavaScriptFromString:scriptCommand];
    
    NSLog(@"-%@", result);
  
}

-(void) inputAccessoryViewDidFinish {
    [self.FilterText resignFirstResponder];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    FilterText.text = [genres objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [genres count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genres objectAtIndex:row];
}


@end

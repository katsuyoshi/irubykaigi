    //
//  WebViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/03.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize requestedUrl, url, domainUrl;

+ (WebViewController *)webViewController
{
    return [[self new] autorelease];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	webView.scalesPageToFit = YES;
    self.view = webView;
    webView.delegate = self;
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [activityIndicatorView release];
    [alertView release];
    [domainUrl release];
    [url release];
    [requestedUrl release];
    [blankUrl release];
    [webView release];
    [super dealloc];
}

- (void)setFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    self.url = [NSURL fileURLWithPath:path];
}

- (NSString *)fileName { return nil; }

- (NSURL *)blankUrl
{
    if (blankUrl == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"html"];
        blankUrl = [[NSURL fileURLWithPath:path] retain];
    }
    return blankUrl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (activityIndicatorView == nil) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        activityIndicatorView.center = webView.center;
        activityIndicatorView.hidesWhenStopped = YES;
        activityIndicatorView.hidden = YES;
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [webView addSubview:activityIndicatorView];
    }

    if (self.url) {
        retryCount = 0;
        [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicatorView stopAnimating];
}

#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    if (++retryCount  < 3) {
        // 読込みに時間がかかる場合があるのでその場合はリトライする
        [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    } else {
        // リトライ後もダメならエラーを表示する
        // load error, hide the activity indicator in the status bar
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [activityIndicatorView stopAnimating];

	// report the error inside the webview
#if DEBUG
        NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
#else
        NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>%@</font></center></html>",
							 NSLocalizedString(@"Failed to load!<br />Please back and try again!", nil)];
#endif
        [webView loadHTMLString:errorString baseURL:nil];
    }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    // AppStoreチェック
    NSString *compURL = @"http://phobos.apple.com/WebObjects/";
    if(NSOrderedSame == [[[request URL] absoluteString] compare:compURL options:NSCaseInsensitiveSearch range:NSMakeRange(0, [compURL length])]) {


        self.requestedUrl = [request URL];
        NSString *appName = @"App Store";
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"This action will close ioTouch2 and open %@. Are you sure to go on?", nil), appName];
        alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
        return NO;
    }

    // AppStoreへのリダイレクトのチェック
    NSArray *redirectPaths = [NSArray arrayWithObjects:@"http://tr.im", @"http://click.linksynergy.com", @"http://itunes.apple.com", nil];
    NSString *path = [[request URL] absoluteString];
    for (NSString *redirectPath in redirectPaths) {
        if(NSOrderedSame == [path compare:redirectPath options:NSCaseInsensitiveSearch range:NSMakeRange(0, [redirectPath length])]) {
            return YES;
        }
    }

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    
        // ローカルのヘルプへのリンク
        NSURL *aUrl = [request URL];
        if ([aUrl isFileURL]) {
            NSString *fileName = [[aUrl path] lastPathComponent];
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
            if (path) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
            }
            return NO;
        } else {
        
            // 同じサイトは開ける
            NSString *domainString = [self.domainUrl absoluteString];
            NSString *urlString = [aUrl absoluteString];
            if ([urlString length] >= [domainString length]) {
                if ([domainString isEqualToString:[urlString substringToIndex:[domainString length]]]) {
                    return YES;
                }
            }
                
            // 外部リンク
            self.requestedUrl = aUrl;
            NSString *appName = [[aUrl path] compare:@"mailto:" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [@"mailto:" length])] == NSOrderedSame ? NSLocalizedString(@"Mail", nil) : NSLocalizedString(@"Safari", nil);
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"This action will close ioTouch2 and open %@. Are you sure to go on?", nil), appName];
            alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertView show];
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:self.requestedUrl];
    }
    [alertView release];
    alertView = nil;
    retryCount = 0;
}

@end

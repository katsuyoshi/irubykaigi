//
//  SummaryViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/16.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SummaryViewController.h"


@implementation SummaryViewController

@synthesize text;


+ (SummaryViewController *)summaryViewController
{
    return [[[self alloc] initWithNibName:@"SummaryViewController" bundle:nil] autorelease];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    textView.text = text;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [text release];
    [textView release];
    [super dealloc];
}


@end

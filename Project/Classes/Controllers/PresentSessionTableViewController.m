//
//  PresentSessionTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//

/* 

  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "PresentSessionTableViewController.h"
#import "CiderCoreData.h"
#import "Day.h"


@implementation PresentSessionTableViewController

@synthesize date;

+ (PresentSessionTableViewController *)presentSessionTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (void)dealloc
{
    [date release];
    [super dealloc];
}

- (NSString *)title
{
    return NSLocalizedString(@"Present sessions", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)setDateNow
{
#ifdef DEBUG
    self.date = [NSDate dateWithYear:2010 month:8 day:27 hour:13 minute:30 second:00];
#else
    self.date = [NSDate date];
#endif
}

- (void)setDateNext
{
#ifdef DEBUG
    [self setNextDateOf:[NSDate dateWithYear:2010 month:8 day:27 hour:14 minute:00 second:00]];
#else
    [self setNextDateOf:[NSDate date]];
#endif
}

- (void)setNextDateOf:(NSDate *)aDate
{
    aDate = [NSDate dateWithTimeInterval:30 * 60 sinceDate:aDate];
    int m = [aDate minute];
    m = (m / 30) * 30;
    self.date = [NSDate dateWithYear:[aDate year] month:[aDate month] day:[aDate day] hour:[aDate hour] minute:m second:0];
}

- (void)reloadData
{
    [self setArrayControllerWithSessionArray:[self.region sessionsForDate:self.date]];
    [self.tableView reloadData];
}


@end

//
//  SessionBySomethingTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
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

#import "SessionBySomethingTableViewController.h"
#import "SessionTableViewCell.h"
#import "SessionDetailedTableViewController.h"
#import "Property.h"
#import "LightningTalkTableViewController.h"


@implementation SessionBySomethingTableViewController

+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self sessionTableViewController]] autorelease];
}

+ (id)sessionTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (void)dealloc
{
    [arrayController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setArrayControllerWithSessionArray:(NSArray *)sessions
{
    [self setArrayControllerWithSessionSet:[NSSet setWithArray:sessions]];
}

- (void)setArrayControllerWithSessionSet:(NSSet *)sessions
{
    [self setArrayControllerWithSessionSet:sessions sortDescriptors:nil];
}

- (void)setArrayControllerWithSessionSet:(NSSet *)sessions sortDescriptors:(NSArray *)sortDescriptors
{
    if (sortDescriptors == nil) {
        sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time, position"];
    }
    [arrayController release];
    arrayController = [[ISSectionedArrayController alloc] initWithSet:sessions sectionName:@"dayTimeTitle" sortDescriptors:sortDescriptors];
    arrayController.sectionTitleName = @"self";
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayController numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayController tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arrayController tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    SessionTableViewCell *cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [SessionTableViewCell sessionTableViewCellWithIdentifier:cellIdentifier];
    }
    cell.session = [arrayController objectAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SessionTableViewCell *cell = (SessionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.session.isLightningTalks) {
        LightningTalkTableViewController *controller = [LightningTalkTableViewController lightningTalksTableViewController];
        controller.masterObject = cell.session;
        [self.navigationController pushViewController:controller animated:YES];
    } else
    if (cell.session.isBreak == NO) {
        SessionDetailedTableViewController *controller = [SessionDetailedTableViewController sessionDetailedTableViewController];
        controller.editingMode = NO;
        controller.detailedObject = [arrayController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}



@end

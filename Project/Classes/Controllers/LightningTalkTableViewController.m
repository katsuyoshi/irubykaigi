//
//  LightningTalksTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/25.
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

#import "LightningTalkTableViewController.h"
#import "LightningTalkTableViewCell.h"


@implementation LightningTalkTableViewController

+ (LightningTalkTableViewController *)lightningTalksTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"LightningTalk";
    self.displayKey = @"title";
    self.detailedTableViewControllerClassName = @"LightningTalkDetailedTableViewController";
}

- (NSString *)title
{
    return [self.masterObject valueForKey:@"title"];
}

- (Session *)session
{
    return (Session *)self.masterObject;
}

- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    return [LightningTalkTableViewCell lightningTalkTableViewCellWithIdentifier:cellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LightningTalkTableViewCell *aCell = (LightningTalkTableViewCell *)cell;
    
    aCell.lightningTalk = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)didChangeRegion
{
    self.masterObject = [self.session sessionForRegion:self.region];
    [self reloadData];
}


@end

//
//  SessionAndLightningTalkBySomethingTableViewController.m
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

#import "SessionAndLightningTalkBySomethingTableViewController.h"
#import "SessionTableViewCell.h"
#import "LightningTalkTableViewCell.h"
#import "LightningTalkDetailedTableViewController.h"


@implementation SessionAndLightningTalkBySomethingTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [arrayController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Session class]]) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    NSString *cellIdentifier = @"LightningTalkCell";
    LightningTalkTableViewCell *cell = (LightningTalkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LightningTalkTableViewCell lightningTalkTableViewCellWithIdentifier:cellIdentifier];
    }
    cell.lightningTalk = (LightningTalk *)object;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SessionTableViewCell class]]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        LightningTalkDetailedTableViewController *controller = [LightningTalkDetailedTableViewController lightningTalkDetailedTableViewController];
        controller.detailedObject = ((LightningTalkTableViewCell *)cell).lightningTalk;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end

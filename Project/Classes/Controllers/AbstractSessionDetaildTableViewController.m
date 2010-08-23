//
//  AbstractSessionDetaildTableViewController.m
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

#import "AbstractSessionDetaildTableViewController.h"
#import "Room.h"


@implementation AbstractSessionDetaildTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:self.navigationItem.backBarButtonItem.title style:UIBarButtonItemStylePlain target:self action:@selector(backAction)] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (self.session) {
        if (self.session.room) {
            if (self.session.room.roomColor) {
                self.tableView.backgroundColor = self.session.room.roomColor;
            }
        }
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)cellHeightForTableView:(UITableView *)tableView text:(NSString *)text indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForTableView:tableView inSection:indexPath.section];
    UIFont *fount = cell.textLabel.font;
    CGSize size = [text sizeWithFont:fount constrainedToSize:CGSizeMake(cell.bounds.size.width - 20 * 2, 44.0 * 10000)];
    float height = size.height + 44.0;

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *referenceCell = [self cellForTableView:tableView inSection:indexPath.section];
    UITableViewCell *cell = [super tableView:tableView  cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = referenceCell.textLabel.font;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    return nil;
}


- (Session *)session
{
    return nil;
}

@end

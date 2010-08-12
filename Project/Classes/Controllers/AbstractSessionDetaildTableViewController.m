//
//  AbstractSessionDetaildTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

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
    UIFont *fount = cell.textLabel.font; // DELETEME: [UIFont fontWithName:cell.textLabel.font.fontName size:17];
    CGSize size = [text sizeWithFont:fount constrainedToSize:CGSizeMake(cell.bounds.size.width, 44.0 * 300)];
    float height = size.height + 44.0;

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *referenceCell = [self cellForTableView:tableView inSection:indexPath.section];
    UITableViewCell *cell = [super tableView:tableView  cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = referenceCell.textLabel.font;
    cell.textLabel.numberOfLines = 0;
NSLog(@"%@", indexPath);
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

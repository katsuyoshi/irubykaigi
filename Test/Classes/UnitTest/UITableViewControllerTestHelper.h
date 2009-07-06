/*
 *  UITableViewControllerTestHelper.h
 *  ioCoreTest
 *
 *  Created by Katsuyoshi Ito on 09/06/20.
 *  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
 *
 */

#define CELL(r,s)	[self.controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(r) inSection:(s)]]

#define NUMBER_OF_SECTIONS()	[self.controller numberOfSectionsInTableView:self.controller.tableView]
#define NUMBER_OF_ROWS_IN_SECTION(s)	[self.controller tableView:self.controller.tableView numberOfRowsInSection:(s)]
#define CELL_FOR_ROW_IN_SECTION(r,s)    [self.controller tableView:self.controller.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(r) inSection:(s)]];
#define SELECT_CELL(r,s)	[self.controller tableView:self.controller.tableView didSelectRowAtIndexPath:]

#define TITLE_FOR_SECTION(s)    [self.controller tableView:self.controller.tableView titleForHeaderInSection:s]

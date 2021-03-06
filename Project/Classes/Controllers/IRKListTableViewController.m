//
//  IRKListTableViewController.m
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

#import "IRKListTableViewController.h"
#import "Property.h"
#import "Importer.h"


@implementation IRKListTableViewController

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    Property *property = [Property sharedProperty];
    [property addObserver:self forKeyPath:@"japanese" options:NSKeyValueObservingOptionNew context:property];
    Importer *importer = [Importer defaultImporter];
    [importer addObserver:self forKeyPath:@"isUpdated" options:NSKeyValueObservingOptionNew context:importer];
}

- (void)dealloc
{
    [[Importer defaultImporter] removeObserver:self forKeyPath:@"isUpdated"];

    [[Property sharedProperty] removeObserver:self forKeyPath:@"japanese"];
    [super dealloc];
}


#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [Property sharedProperty]) {
        if (keyPath == @"japanese") {
            [self didChangeRegion];
        }
    }
    if (context == [Importer defaultImporter]) {
        [self reloadData];
    }
}

#pragma mark -
#pragma mark reloadData

- (void)reloadData
{
    [self resetFetchedResultController];
    [super reloadData];
}


#pragma mark -
#pragma mark properties

- (Region *)region
{
    return [Property sharedProperty].japanese ? [Region japanese] : [Region english];
}

- (void)didChangeRegion
{
    @try {
        [self reloadData];
    }
    @catch (NSException * e) {
        NSLog(@"%@", e);
    }
}



@end

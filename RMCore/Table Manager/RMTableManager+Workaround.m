//
//  RMTableManager+Workaround.m
//  RMCore
//
//  Created by Loyal Tingley on 7/21/17.
//  Copyright © 2017 Ryan Mannion. All rights reserved.
//

#import <RMCore/RMCore-Swift.h>

@implementation RMTableManager (Workaround)

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath ? [self __workaroundTableView:tableView editActionsForRowAtIndexPath:indexPath] : @[];
}

@end

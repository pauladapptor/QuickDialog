#import "QuickDialogIndexedDataSource.h"

@interface QuickDialogIndexedDataSource() {
@private
    __unsafe_unretained QuickDialogTableView *_tableView;
}
@end

@implementation QuickDialogIndexedDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_tableView.root getVisibleSectionForIndex:section].title;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return 0;
}

@end



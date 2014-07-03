#import <UIKit/UIKit.h>

@interface UITableViewCell (NIB)

+ (NSString*)cellID;
+ (NSString*)nibName;

+ (id)dequeOrCreateInTable:(UITableView*)tableView;
+ (id)loadCell;

+ (id)loadCellWithNibName:(NSString*)nibName;
+ (id)dequeOrCreateInTable:(UITableView*)tableView withNibname:(NSString*)nibName;
@end

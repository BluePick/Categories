#import "UITableViewCell+NIB.h"

@implementation UITableViewCell (NIB)

+ (id)loadCell {
    return [self loadCellWithNibName:[self nibName]];
}
+ (id)loadCellWithNibName:(NSString*)nibName {
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	
	for (id object in objects) {
		if ([object isKindOfClass:self]) {
			UITableViewCell *cell = object;
			[cell setValue:nibName forKey:@"_reuseIdentifier"];	
			return cell;
		}
	}
    
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", nibName, [self class]];	
	
	return nil;
}


+ (NSString*)cellID { return [self description]; }


+ (NSString*)nibName { return [self description]; }


+ (id)dequeOrCreateInTable:(UITableView*)tableView {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellID]];
	return cell ? cell : [self loadCell];
}

+ (id)dequeOrCreateInTable:(UITableView*)tableView withNibname:(NSString*)nibName{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:nibName];
	return cell ? cell : [self loadCellWithNibName:nibName];
}

@end

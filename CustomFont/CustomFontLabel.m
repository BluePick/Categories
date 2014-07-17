
#import "CustomFontLabel.h"

@implementation CustomFontLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:self.tag?@"Whipsmart":@"Whipsmart-Bold" size:self.font.pointSize];
}

@end

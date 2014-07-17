

#import "CustomFontButton.h"

@implementation CustomFontButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:self.tag?@"Whipsmart":@"Whipsmart-Bold" size:self.titleLabel.font.pointSize];
}

@end

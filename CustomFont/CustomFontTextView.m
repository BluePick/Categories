

#import "CustomFontTextView.h"

@implementation CustomFontTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:self.tag?@"Whipsmart":@"Whipsmart-Bold" size:self.font.pointSize];
}

@end

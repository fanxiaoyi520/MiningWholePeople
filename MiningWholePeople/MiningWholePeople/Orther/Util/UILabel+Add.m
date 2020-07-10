//
//  UILabel+Add.m
//  JJSliderViewController
//
//  Created by FANS on 2020/7/3.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)

- (void)multiLineDisplay
{
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height);
}
@end

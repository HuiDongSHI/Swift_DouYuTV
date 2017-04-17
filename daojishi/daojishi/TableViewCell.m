//
//  TableViewCell.m
//  daojishi
//
//  Created by HuiDong Shi on 2017/4/17.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

#import "TableViewCell.h"
@interface TableViewCell()
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation TableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setMin:(NSInteger)min{
    _min = min;
    
    [self.timer invalidate];
    
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.textLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", self.min/60,self.min%60];
}

- (void)timeDown{
    self.min --;
    if (self.min < 0) {
        self.textLabel.text = @"列车已到站";
    }else{
        if (self.min < -40){
            
        }else{
          
        }
          self.textLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", self.min/60,self.min%60];
    }
}



- (void)setTimer{
    
}

//- (NSTimer *)timer{
//    if (_timer) {
//       
//       
//    }
//    return _timer;
//}

@end

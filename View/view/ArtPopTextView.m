//
//  ArtPopTextView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ArtPopTextView.h"
#import "StepSlider/StepSlider.h"

@interface ArtPopTextView()

@property (weak, nonatomic) IBOutlet StepSlider *sliderView;


@end

@implementation ArtPopTextView

-(instancetype)init{
    if(self = [super init]){
        [[NSBundle mainBundle]loadNibNamed:@"ArtPopTextView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.sliderView.maxCount = 4;
        self.sliderView.trackCircleRadius = 0.f;
  
        self.sliderView.labelFont = FontOfSize(13);
        self.sliderView.labelColor = BlackColor999999;
        self.sliderView.labelOffset = 5.f;
        self.sliderView.labels = @[@"小", @"中", @"大", @"极大"];
        self.sliderView.labelOrientation = StepSliderTextOrientationUp;
        
        self.sliderView.sliderCircleImage = [UIImage imageNamed:@"椭圆"];
        if (self.selectedIndex < self.sliderView.maxCount) {
             self.sliderView.index = self.selectedIndex;
        }
       
     
    }
    return  self;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex!=selectedIndex) {
        _selectedIndex = selectedIndex;
        if (selectedIndex < self.sliderView.maxCount) {
            [self.sliderView setIndex:selectedIndex];
        }
        
    }
}
- (IBAction)changevalue:(StepSlider * )sender {
    if(self.delegate){
        [self.delegate chooseValue:sender.index];
    }
}

@end

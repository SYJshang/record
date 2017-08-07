//
//  SYJMineCell.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/4.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJMineCell.h"

@implementation SYJMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.img = [[UIImageView alloc]init];
        [self.contentView addSubview:self.img];
        self.img.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 10).heightIs(34).widthIs(34);
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.font = [UIFont systemFontOfSize:16.0];
        self.nameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.sd_layout.leftSpaceToView(self.img, 10).centerYEqualToView(self.contentView).heightIs(20).widthIs(200);
        
        self.access = [[UIImageView alloc]init];
        [self.contentView addSubview:self.access];
        self.access.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,10).heightIs(20).widthIs(20);
        
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

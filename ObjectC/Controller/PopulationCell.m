#import "PopulationCell.h"
@implementation PopulationCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setPopulation:(PopulationModel*)populationModel{
    self.populationLabel.text = [NSString stringWithFormat:@"%f", populationModel.population];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)populationModel.year];
    self.id_yearLabel.text = [NSString stringWithFormat:@"%ld", (long)populationModel.id_year];
    self.id_nationLabel.text = populationModel.id_nation;
    self.nationLabel.text = populationModel.nation;
    self.slug_nationLabel.text = populationModel.slug_nation;
}
-(IBAction)actionPopulation:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionPopulation:)]) {
        [self.delegate actionPopulation:self];
    }
}
@end

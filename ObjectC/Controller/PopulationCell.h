#import <UIKit/UIKit.h>
#import "PopulationModel.h"
@class PopulationCell;
@protocol PopulationCellDelegate <NSObject>
-(void)actionPopulation:(PopulationCell *)cell;
@end
@interface PopulationCell : UITableViewCell
@property (weak) IBOutlet id<PopulationCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet CTHLabel *populationLabel;
@property (weak, nonatomic) IBOutlet CTHLabel *yearLabel;
@property (weak, nonatomic) IBOutlet CTHLabel *id_yearLabel;
@property (weak, nonatomic) IBOutlet CTHLabel *id_nationLabel;
@property (weak, nonatomic) IBOutlet CTHLabel *nationLabel;
@property (weak, nonatomic) IBOutlet CTHLabel *slug_nationLabel;
-(void)setPopulation:(PopulationModel*)populationModel;
@end

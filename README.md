# VE-cadherin-Patch-Classification

A quantitive image analysis software developed by Andrew Philippides, written in Matlab, for the 2014 paper ‘The role of differential VE-cadherin dynamics in cell rearrangement during angiogenesis’  published in nature cell biology: [Bentley, K., Franco, C., Philippides, A. et al. The role of differential VE-cadherin dynamics in cell rearrangement during angiogenesis. Nat Cell Biol 16, 309–321 (2014)](https://doi.org/10.1038/ncb2926). 

The software was used to both automatically and manually classify the VE-cadherin pattern in individual square patches of 3D projections of confocal image z-stacks of blood vessels.

## Initial Setup

1. **Set Path:** To let Matlab know where to look for commands, the path to the source code must be set. Open Matlab and click ‘Set Path’ in the Home tab. In the window that pops up click ‘Add with Subfolders…’ and navigate to the folder where the source code is then save and close. This only needs to be done once.

![initial setup set path](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/initial_setup_part1.gif)

2. **Be aware of current folder** When using the software, Matlab’s current folder must be set to the location of the .tif or .lsm files you want to be classified.

![initial setup current folder example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/initial_setup_part2.gif)

## Program use

The ‘PatchAndClassifyFiles’ command acts as the main function for the program. Type this command into Matlab’s Command Window to be presented with the list of commands:

  1. **Mask and patch files in the folder**
     * Creates a mask of the images in the current folder and splits the images into patches. These patches are saved as separate .mat files. This only needs to be done once.

  2. **Hand classify**
     *	Hand classify the .mat files in the current folder.

  3. **Show and save results (CSVs + plots)**
     * Displays plots of results and saves these results to .csv files

  4. **Show and save results (reconstruct images as heatmaps)**
     * Reconstructs and saves the images as heatmaps

  5. **Pick Thresholds for the auto classification**
  6. **Auto classify**
  7. **See results from auto classification**
  8. **Show coloc data and reconstruct coloc image**
  9. **Combine hand classify results**
  0. **Exit**

### Command 1: Mask and patch files in the folder

Files can be processed as either individual images or stacks of images. You will be presented with this option first.

Then enter the mask channel, followed by the channel you want to classify on then whether you want a colocalised channel.
Figures will be presented after choosing these options. It is recommended that you dock these figures into Matlab so they can be viewed above the command window.

You will be asked for the threshold for each slice. Enter a new threshold or -1 to ignore the current slice. If you do not want to ignore the current slice, once the desired threshold is entered, press return. This will create the .mat files for each patch of the slice.

![command 1 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command1.gif)


### Command 2: Hand classify

This command will randomise the patches in the current folder and cycle through them, stopping to give you the opportunity to classify each one. Once classified, a new .mat file is created for the patch in a ‘HandClassified’ subfolder, saving its classification.

Each slice can be classified as 1: Remodelling, 2: Stable, 3: Mixed, 4: Empty.

For classification 1 and 2 you will also need to enter the ‘strength’ of this classification. A value from 1: high, 2: medium,  3: low. 

![command2 part1 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command2_part1.gif)

If classification 3 is chosen, as it is mixed you will need to enter the strength of how ‘Remodelling’ the image is and then the strength of how ‘Stable’ it is.

![command2 part2 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command2_part2.gif)

Whilst cycling through, text above the image shows the current patch number out of the total. The text below will show the classification of the patch  and the strength of this classification if the patch has already been classified. Once all patches have been given a classification ‘ALL PATCHES CLASSIFIED’ will be prefixed to the patch number text above the image. However, you can still cycle through the patches choosing new classifications / strengths. You will also have the option to cycle back through the patches by entering 0 to go back to the previous patch.

Once all patches have been classified. Enter 5 to end classification. This will then automatically run command 3.

### Command 3: Show and save results (CSVs + plots)

Collates results from groups of files or all files into plots and CSVs. These results are displayed and saved into the ‘HandClassified’ subfolder.

The command will first display all the hand classified .mat files in the HandClassified folder. By default, it assumes that the files are grouped by ‘ctrl’ and ‘mutant’ prefix to the ‘_Patch*patch number*HandClassRnd.mat’ files. If this is the case press enter. If the files are grouped by different prefixes or if you want to group all the files together press 0. This will ask you to enter the file starts to all the different groups or pressing return on its own will group all the files. Once finished, the plots will be displayed and the results will be saved into three different csvs: ‘num_patches_strong_remodelling_to_strong_stable.csv’, ‘number_non_empty_patches_and_total_num_patches.csv’ and ‘percent_patches_strong_remodelling_to_strong_stable.csv’. The plot will be saved as ‘handclassified_results_plot.png’.

![command3 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command3.gif)

### Command 4: Show and save results (Show and save results (reconstruct images as heatmaps)

Reconstructs and saves the images as heatmaps. These are saved into a ‘Heatmaps’ subfolder within the Handclassified folder as .tiff files.

![command4 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command4.gif)


### Command 5: Pick Thresholds for the auto classification

You will first be given the option to auto classify based on a std deviation filter or based on the raw image.

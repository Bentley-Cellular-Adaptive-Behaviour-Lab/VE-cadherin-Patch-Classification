# VE-cadherin-Patch-Classification

A quantitive image analysis software written in Matlab, developed by [Andrew Philippides](https://profiles.sussex.ac.uk/p23611-andy-philippides) (University of Sussex) in collaboration with [Katie Bentley](https://www.crick.ac.uk/research/labs/katie-bentley) (while at Cancer Research UK, LRI / Beth Israeal Medical Center, Harvard Medcial School US) for the 2014 paper ‘The role of differential VE-cadherin dynamics in cell rearrangement during angiogenesis’  published in nature cell biology: [Bentley, K., Franco, C., Philippides, A. et al. The role of differential VE-cadherin dynamics in cell rearrangement during angiogenesis. Nat Cell Biol 16, 309–321 (2014)](https://doi.org/10.1038/ncb2926). 

The software was used to 1) manually classify VE-cadherin junctional patterns in individual square patches of 3D confocal image z-stacks of blood vessels aswell as 2) automatically extract and quantify morphological features of segmented objects in the patches.

**Please note that the software was designed collaboratively between Bentley and Philippides so that parameters such as: patch size, definition of small/large objects, object properties to display such as wiggliness, hand classification classes), etc; were co-designed for the problem at hand. While they have proved useful in other studies if you need to vary parameters, or if you would like help to characterise a particular feature or texture you see in patches (see Section 7), please get in touch via email or open an issue on the repository as we may be able to help. Likewise, if you have suggestions for features (see eg section 6) get in touch. And finally, if you do use the software, we’d be grateful if you could get in touch via email to let us know.**

Andrew Philippides: andrewop@sussex.ac.uk

Katie Bentley: katie.bentley@crick.ac.uk

Kelvin van Vuuren: kelvin.van-vuuren@crick.ac.uk

## Citation
If you use or modify this software please cite the Nature Cell paper linked above. However, a methods paper will be published soon which we would prefer to be cited once available.

## Planned features

An implementation of automated classification is planned for development soon. 

We are also keen to extend the codebase in other ways and are open to any suggestions / collaborations. If you modify the codebase and think any new developments would be useful to add into this repository, please open a pull request or get in contact via email.

## Initial Setup

1. **Set Path:** To let Matlab know where to look for commands, the path to the source code must be set. Open Matlab and click ‘Set Path’ in the Home tab. In the window that pops up click ‘Add with Subfolders…’ and navigate to the folder where the source code is then save and close. This only needs to be done once.

![initial setup set path](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/intial_setup_part1.gif)

2. **Be aware of current folder** When using the software, Matlab’s current folder must be set to the location of the .tif or .lsm files you want to be classified.

![initial setup current folder example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/initial_setup_part2.gif)

## Program use

The ‘PatchAndClassifyFiles’ command acts as the main function for the program. Type this command into Matlab’s Command Window to be presented with the list of commands:

  0. **Exit**
     * Exit the PatchAndClassifyFiles command loop
  
  1. **Mask and patch files in the folder**
     * Creates a mask of the images in the current folder and splits the images into patches. These patches are saved as separate .mat files. This only needs to be done once.

  2. **Hand classify**
     *	Hand classify the .mat files in the current folder.

  3. **Show and save results (CSVs + plots)**
     * Displays plots of results and saves these results to .csv files

  4. **Show and save results (reconstruct images as heatmaps)**
     * Reconstructs and saves the images as heatmaps

  5. **Pick Thresholds for the auto classification**
     * Allows user to pick threshold based either on std deviation filter or raw image with options to adjust this threshold 
     * Runs auto classification based on chosen threshold when confirmed.
     
  6. **Auto classify**
     * Runs auto classification which can be based on one five available options.
     * Automatically outpots and plots results
     
  7. **See results from auto classification**
     * Displays auto classification results based on either std deviation filter, raw image or combined data from multiple files

  

### Command 1: Mask and patch files in the folder

Files can be processed as either individual images or stacks of images. You will be presented with this option first.

Then enter the mask channel, followed by the channel you want to classify on then whether you want a colocalised channel. If you include a colocalised channel it means you can compare how the area of signal over a threshold in a different channel correlates with the classified shape of VEcaderin in each patch, e.g. to see whether cells with more active junctions are also higher in exression of a certain protein. 

Figures will be presented after choosing these options. It is recommended that you dock these figures into Matlab so they can be viewed above the command window. To dock click the little curved black arrow in the top corner of the figure.

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

You will first be given the option to auto classify based on a std deviation filter or based on the raw image. You can switch this later if it looks like the other option works better (see below).

Dock the figure that appears. 4 images are shown on this figure:
- Top left: original image
- Bottom left: std deviation filtered image of raw image
- Top right: shows all the above threshold objects
- Bottom right: shows each object given the current threshold. Each object has a unique colour.

![command 5 example 1](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command5_1.gif)

Hover and click on the docked figure to select the window. This will allow the following commands to be inputted:
- **UP arrow:** increase threshold
- **DOWN arrow:** decrease threshold
- **T:** switch between std deviation filter and raw image (this will change the 'THRESHOLDING THIS' text to switch to the currently selected)
- **N:** move to next patch. Use this to check current threshold is compatible with other patches.
- **Return:** confirm threshold value and run an auto classification based on this hand picked threshold (equivalent to option 2 from command 6).

![command 5 example 2](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command5_2.gif)

### Command 6: Auto classify

Runs auto classification based on one of the following options:
1) Hand picked threshold (based on standard deviation filter) from command 5.
2) Hand picked threshold (based on raw image) from command 5.
3) Pre-set threshold per slice (based on raw image). The hand picked threshold from command 5 applied to every slice in the image.
4) Auto threshold per slice (based on raw image)
5) Auto threshold per patch (based on raw image)

**If you would instead like to use a pre-set threshold (or range of thresholds) for all images (as a sensitivity analysis) or to eg use an automatic thresholding per slice or per patch, please get in touch via email as we may be able to implement this. 
After processing command 7 will automatically be run. The results from this command will be shown so the initial requirement in command 7 to declare which results to show is skipped.** 

![command 6 example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command6.gif)

### Command 7: See results from auto classification

**The auto classifier outputs the distributions of large (area >= 50) and small (area >= 10 and <50) objects, as well as the mean eccentricity and mean wiggliness of the large objects and correlates these features with hand classification (if this has been performed). Please note that many other parameters can be extracted and shown (e.g. % of patch above threshold, mean intensity of above threshold objects, etc). Alternatively, it is possible that we can characterise a particular feature or texture you see in patches and extract this as a parameter. Please get in touch via email if so as we may be able to help.**

Outputs auto classification results from either:
1) std deviation filter 
2) raw image
3) combined data from multiple files. This can be used to combine data from other folders with the auto classification results from the current folder.

You will be asked how to group the data. Enter the number of groups you want or 0 to group each file separately or press return to put include all files into one group.

If a number of groups is entered then the list of file numbers and their corresponding file names will be displayed. Enter the numbers of the file you want to be in the current group and press return. Either repeat again to add a different file into the current group or if finished enter return on its own. This will be repeated for each of the specified groups.
Note: if you have included a file in multiple groups or haven’t selected all files in the comparison the warning:

****** SOME DUPLICATES ******  or ****** NOT ALL PATCHES USED ******
          
will be shown.


![command 7 group files example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command7_1.gif)

The following figures will be displayed:
 - **Figure 1:** Box plots of number of big objects for each group
 - **Figure 2:** Histogram of number of big objects for each group
 - **Figure 3:** Box plots of number of small objects for each group
 - **Figure 4:** Histogram of number of small objects for each group
 - **Figure 5:** Mean and std deviation 'wigglyness' box plot of big objects for each group
 - **Figure 6:** Histogram of 'wigglyness' (remodelling) of big objects for each group
 - **Figure 7:** Mean and std deviation eccentricity box plots of big objects for each group
 - **Figure 8:** Eccentricity histogram of the big objects for each group

If you have hand-classified the files, the figures after the initial 8 contain 4 subplots which correlate the deatures extrackedn with the hand classification:

|         |            |
| ------------- | ------------- |
| **Top left:** Number of big objects from the hand classified results      | **Top right:** Number of small objects from the hand classified results |
| **Bottom left:** Mean and std deviation 'wigglyness' (remodelling) box plot of big objects from hand classified results      | **Bottom right:** Mean and std deviation eccentricity box plot of big objects from hand classified results      |


 - **Figure 9:** Results from all groups included together
 - **Figure 10+:** One of these figures for each individual group

![command 7 figure output example](https://github.com/Bentley-Cellular-Adaptive-Behaviour-Lab/VE-cadherin-Patch-Classification/blob/master/gifs/command7_2.gif)


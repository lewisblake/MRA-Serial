# Multi-resolution approximation model, v1.0: Serial Implementation
December 28, 2018

Software authors:
Lewis Blake, Colorado School of Mines (lblake@mines.edu)
Dorit Hammerling, Colorado School of Mines (hammerling@mines.edu)


This codebase is based on the MRA model described in
"A multi-resolution approximation for massive spatial datasets" by Matthias Katzfuss, 2017 in 
the Journal of American Statistical Association (DOI: 10.1080/01621459.2015.1123632)
Also at arXiv: https://arxiv.org/abs/1507.04789
References to this manuscript are found throughout the codebase.


Designed and implemented with MATLAB 2018a (Version 9.4)
Previous versions may not be supported.
Required toolboxes:
- Statistics and Machine Learning Toolbox
- Optimization Toolbox

## GETTING STARTED:
This MATLAB codebase allows users to apply the multi-resolution approximation model to 2D spatial data sets.

The user_input.m script is where much of the user input can be modified (see USER INPUT and ADDITIONAL USER INPUT below).
If desired, users should modify model parameters within user_input.m.
The main.m script runs the model. 
Within the Matlab Editor Tab, selecting the 'Run' button from main.m will execute the code.

The codebase is structured as follows: The user_input.m script, the main.m script, the find_num_levels_suggested.m function, LICENSE.txt, and READ_ME.txt are contained within the 'Serial MRA' folder.
Within the 'Serial MRA' folder, there are four other folders: 'Data, 'Results', 'Plots', and 'subroutines'.
The 'Data' folder contains example data sets.
The 'Results' folder is the default folder for spatial prediction results to be dumped. Initially empty.
The 'Plots' folder is the default folder for spatial prediction plots to be dumped. Initially empty.
The 'subroutines' folder contains the functions used to execute the model, and no other scripts.


## EXAMPLE DATA:
Two data sets are included in this distribution: satelliteData.mat and simulatedData.mat. 
These files are contained within the 'Data' folder.
Both of these datasets were originally presented in Heaton, M.J., Datta, A., Finley, A.O. et al. JABES (2018). https://doi.org/10.1007/s13253-018-00348-w

## PRELIMINARIES:

### find_num_levels_suggested.m

This is a stand-alone function and is not part of the subroutines.
This function estimates the NUM_LEVELS_M for a given dataset size (NUM_DATA_POINTS_n), number of knots (NUM_KNOTS_r), and number of partitions (NUM_PARTITIONS_J).
Note that NUM_LEVELS_M is a positive integer.


## USER INPUT:

### user_input.m

In user_input.m, the areas requiring user input are as follows:

dataSource: | 'satellite' | 'simulated' |
    - These are the dataSource's for the data provided. 
    - In order to use a different data set, see the section of load_data.m below and feed the case string for the data used to dataSource in user_input.m.

calculationType: | 'prediction' | 'optimize' | 'likelihood' |
calculationType can be set to any of the following calculation modes:
	- prediction: Uses given values for the parameters (theta and varEps) and just conducts spatial prediction. Parameters can be changed in load_data.m	
	- optimize: Optimizes over the range, variance (theta) and measurement error (varEps).	
	- likelihood: Calculates the log-likelihood.

displayPlots: Boolean variable indicating whether to display plots if predicting.
savePlots: Boolean variable indicating whether to save plots if predicting.
(Note: If not executing the 'prediction' calculationType, these booleans are not relevant.)

verbose: Boolean variable indicating whether to produce progress indicators.

NUM_LEVELS_M: Total number of levels in the hierarchical domain-partitioning. By default set to 9.

NUM_PARTITIONS_J: Number of partitions for each region at each level. Only implemented for J = 2 or J = 4. By default set to 2.

NUM_KNOTS_r: Number of knots per partition. By default set to 64.

offsetPercentage: Offset percentage from partition boundaries. Must be between 0 and 1.
This quantity determines the buffer between the boundaries of a region where knots can be placed.
offsetPercentage is also used at the coarsest resolution to extend the maximal x and y domain boundaries as to include datapoints that may be exactly on the boundary within a region.
The domain boundaries define a rectangular region defined by the minimal and maximal x and y coordinate locations.
Preferably set offsetPercentage to be a smaller number (e.g. 0.01).

nXGrid: Number of prediction grid points in x-direction. By default set to 200.
nYGrid: Number of prediction gridpoints in y-direction. By default set to 200.
(Note: These parameters define a nXGrid x nYGrid prediction grid of spatial prediction locations if predicting.)

resultsFilePath: Optional file path to save prediction results. 
Set to be a string (e.g. resultsFilesPath = '/Users/JerryGarcia/Desktop/';). 
By default prediction results are dumped in the 'Results' folder.

plotsFilePath: Optional file path to save prediction plots if plotting.
Set to be a string (e.g. plotsFilesPath = '/Users/JerryGarcia/Pictures/';).
By default plots are dumped in the 'Plots' folder.

## ADDITIONAL USER INPUT

### load_data.m 

In load_data.m the user can specify the data being used and the file path. 
The file paths are presently relative for using the data provided. 
Data in other locations can be loaded using absolute files paths. 
In order to use a different data set, a new case within the switch clause must be added with the case given as a string, a file path to the data set with the load() function, and appropriate values for theta and varEps. 
If these values are not known, they can be given lower and upper bounds and then estimated using the 'optimize' calculationType. 
An example of what a case for a new data set may be is as follows.

e.g., Within the switch clause, specify:
case 'myData'
load('/Users/JerryGarcia/Documents/Data/myData.mat')
theta = [2, 1]; varEps = 0.01;

Data being used must have three columns 'lat', 'lon', and 'obs' denoting latitude, longitude, and the observations or be coerced from their native format into variables with those names.

The user can also change the values of theta and varEps in load_data.m.
Values can determined by the 'optimize' mode. For the 'satellite' and 'simulated' data provided, those values determined by the 'optimize' mode are set as the default values.

### evaluate_covariance.m 

evaluate_covariance is a general covariance function. By default, it is set as an exponential and can be changed here.


## OUTPUT: 

Model output is dependent on the calculationType (computational mode) performed. 

1) For the 'prediction' mode, the output is a .mat file with the MRA results. This .mat file contains the prediction locations, prediction mean, and the prediction variance.
If either boolean variables 'displayPlots' or 'savePlots' are set to true, three plots are also produced corresponding to the observations, predicted values, and the prediction variance with the create_plots() function. 
If computing on a remote server without a GUI, saving these images produced in main.m will be needed.
Saving the plots produces can be accomplished by setting savePlots to true in user_input.m. 

2) For the 'optimize' mode, optimized values for theta and varEps are stored within their variables names in the workspace. 

3) The 'likelihood' mode returns the log-likelihood to the command window if verbose is true. Otherwise, sumLogLikelihood will contain the log-likelihood in the workspace.

## NOTE:
If computing on a remote server and file pathing is an issue, comment out the call addpath('subroutines') in main.m and copy files in subroutines into the same folder as main.m. 
This may also be necessary for data sets as well.

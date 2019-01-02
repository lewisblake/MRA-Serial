%% USER_INPUT for the MRA model
% Script where users can set parameters
%
%   Authors: Lewis Blake, Colorado School of Mines (lblake@mines.edu)
%            Dorit Hammerling, Colorado School of Mines (hammerling@mines.edu)
%
%   calculationType specifies what is calculated. 
%   Option 'prediction' uses a default values for the parameters and conducts prediction
%   Option 'optimize' optimizes over the range, variance and measurement
%   error using MLE
%   Option 'likelihood' only calculates the log-likelihood.
%

%% Workspace cleanup and add file path to subroutines
clear all; addpath('subroutines');
%% User Input: Data Type and Model Parameters

% Choose dataSource. Set to be a char corresponding to a case within the
% swtich clause of load_data.m
% Included data sets are 'satellite' and 'simulated'.
dataSource = 'satellite'; % Default is 'satellite'.

% Choose calculationType: | 'prediction | 'optimize' | 'likelihood' |
calculationType = 'likelihood'; % Default is likelihood
% Below are the choices for M, J, and r as denoted in Katzfuss 2017.
% To estimate NUM_LEVELS_M, see find_num_levels_suggested_required.m. J must either be 2 or 4.
NUM_LEVELS_M = 9; % Total number of levels. Set to be a natural number. Deafult is 9.
NUM_PARTITIONS_J = 2; % Number of partitions of each region at each level. Set to be 2 or 4. Default is 2.
NUM_KNOTS_r = 64; % Number of knots per partition. Default is 64.
offsetPercentage = 0.01; % Offset percentage from partition boundaries. Default is 0.01.


%% Inputs relevant if calculationType = 'prediction'.
% That is, these inputs are only used in prediction mode.
displayPlots = true; % Boolean variable indicating whether to display plots when executing the 'prediction' calculationType. Default is true.
savePlots = false; % Boolean variable indicating whether to save plots when executing the 'prediction' calculationType. Default is false.
verbose = true; % Boolean variable indicating whether to display progress indicators. Default is true.
nXGrid = 200; % Number of prediction grid points in x-direction. Only required for 'prediction' calculationType. Default is 200.
nYGrid = 200; % Number of prediction grid points in y-direction. Only required for 'prediction' calculationType. Default is 200.
% Optional: select file paths to save prediction results and plots if
% predicting. e.g. resultsFilesPath = '/Users/JerryGarcia/Desktop/';
resultsFilePath = './Results/';  % By default, prediction results are dumped into Results folder
plotsFilePath = './Plots/'; % By default, plots are dumped into Plots folder

%% Inputs relevant if calculationType = 'optimize'
% Limits and initial values for parameter search
lowerBound = [0,0,0]; % Default is [0,0,0]
upperBound = [10,1,5]; % Default is [10,1,5]
initalEstimate = [5,0.3,0.1]; % Default is [5, 0.3, 0.1]



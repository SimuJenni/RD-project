		Ciliary Beating Analysing Tool (CBAT)

What is it?
-----------

CBAT is a Matlab tool for the automatic analysis of ciliary beating movies. It can be used to batch-analyse videos with respect to cilia beating frequency, tissue activity and other useful metrics. The computed results can then for example be inspected via a provided GUI. 


Requirements
------------
- Matlab (ver2015b or newer) with the following Toolboxes:
	- Image_toolbox
	- statistics_toolbox
	- wavelet_toolbox
	- distrib_computing_toolbox (optional for parallel computing)


Setup
-----
To use the tool you have to first set the following global variables in setup.m:

- fs: Specifies the sampling frequency of the videos (default=90)
- videoDir: Directory where the video-data to be analysed is stored
- extractedDir: Directory where the extracted data from the videos is stored
- resultsDir: Directory where the results are stored


Getting Started
---------------
The usage of the main functionality of the tool is demonstrated in the demo.m script.
This script will walk you through the analysis of a batch of videos in the specified folders and introduce all the main functions.  
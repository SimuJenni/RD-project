# RD-project
This repository is part of the R&D Workshop class taught in Neuchâtel in the Spring semester of 2016.
The authors of this project are Simon Jenni and Laurent Hayez. The supervisor of this project is Patrice Leroy.

Goal of the project
-------------------
The main goal of the project was to implement a Matlab toolbox to automate the anaylsis of cylia beating movies.

Requirements/Wishes from supervisor
----------------------------------
- The documentation should be minimal, but with explicit variables names 
- Explain the shape of input parameters.

Implementation
--------------
The implementation contains the following tools.
- Batch processing from a folder and its subfolder or single file
- Import uncompressed 8bit grey scale .avi files
- Potentially smooth the cilia beating "movie" --> method* : customizable 3D kernel.
- After smoothing, implement the processing by pixel or ROI (size multiple of 4x3 pixels)
- Score tissue surface activity (methods : simple descriptive statistics (variance), entropy, or FFT power)
- Save colored image of the surface activity (bounds of color map  defined by a descriptive statistic (using percentiles : PXX/P(100-XX) XX in [0-50] or defining the min/max of the color map using N class maximizing the entropy and then min/max are located --> Class 1 || min || Class 2 .... Class N-1 || max || Class N
- Keep this image as a potential mask for the following of the process.
- Determine the main frequency or the distribution of frequency given the pixel or ROI --> methods : peak detection using autocorrelation, FFT, wavelet transform.
- If tissue shows region having a similar beating frequency, show the phase of the beating frequency

In addition to this, it contains a GUI tool to analyze easily the obtained results. Note that this GUI is just for analysing the results, and not to compute them

Research part
-------------
- Evaluate the effect of ROI size (pixel, 4x3 ROIs, 8x6 ROIs, ... )
- Evaluate the probable shape of the beating pattern on a by "cilia beating movie" basis.
- Short comparison of the methods used.

Other
-----
The folder doc contains all the documentation such as the slides of the presentations, report and worklog.

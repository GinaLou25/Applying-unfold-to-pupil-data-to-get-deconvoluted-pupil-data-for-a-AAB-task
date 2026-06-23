# Applying-unfold-to-pupil-data-to-get-deconvoluted-pupil-data-for-a-AAB-task
In this project (my bachelor thesis) I created an option to get pupil data into EEGLAB, to pass it on to unfold for deconvolution. The code is specificly written for the data of one Approach-Avoidance-Experiment (conducted by Aitana-Grasso-Cladera) and therefore not easily mathed to different projects. 

Data files needed (not provided, as the data does not belong to me):
- behavioral reaction time
- side
- valence
- frame onset latency
- first fixation latency
- reaction type
- saccade Start latency
- saccade End latency
- picture Onset index
- fixation cross index
- start task index
- start valid trials index
- block order
- picture sequence
- pupil Size
- time vector
- noSaccadeMask --> created by me and included in the repository
- saccadeDuration0Mask --> created by me and included in the repository

Toolboxes needed:
- EEGLAB
- Unfold

Extensions that might be needed (unsure which ones I actually used)
- gramm
- cbrewer
- daviolinplot
- Image Processing Toolbox
- Siganl Processing Toolbox
- Statistics and Machine Learning Toolbox

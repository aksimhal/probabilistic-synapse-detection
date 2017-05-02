### Downloading the data 

The original data is hosted by Neurodata.io and they provide the offical support to access and download the data.  I've provided scripts which I've used to download the data, but they may not work in the future.  If you run into any issues, feel free to create either a github issue or email me directly at anish.simhal@duke.edu.  


Prior to running the scripts, the 'ndio' python package must be installed: 'pip install ndio==1.1.5'

To download the larger conjugate array tomography dataset, use this script: nd_download_conjugateAT_gelatin.py.  The manual synapse annotations: https://drive.google.com/file/d/0B-klet4qHv35NVJYSDI1WUFiVHM/view?usp=drive_web


To download the smaller conjugate array tomography dataset, use this script: nd_download_conjugateAT_silane.py. The manual synapse annotations: https://drive.google.com/file/d/0B-klet4qHv35blJTbkI1OVRSeTg/view?usp=drive_web 

To download the chessboard dataset, nd_download_chessboard.py

For each script, change the local download locations to your own machine.  

#### Original Data references. 
The conjugate array tomography data was originally published here: http://www.jneurosci.org/content/35/14/5792.  It can be downloaded here: https://neurodata.io/data/collman15.  The chessboard dataset was originally published here: http://www.nature.com/articles/sdata201446 and can be downloaded here: https://neurodata.io/data/weiler14. 

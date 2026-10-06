This README.txt file was generated on <20200715> by Alireza Chamanzar

#
# General instructions for completing README: 
# For sections that are non-applicable, mark as N/A (do not delete any sections). 
# Please leave all commented sections in README (do not delete any text). 
#

-------------------
GENERAL INFORMATION
-------------------

1. Title of Dataset: 

Ultra high-density EEG recording of interictal migraine and controls: sensory and rest

We used a high-density electroencephalography (HD-EEG) system, with 128 customized electrode locations, to record from 17 individuals with migraine (12 female) in the interictal period, and 18 age- and gender-matched healthy control subjects, during visual (vertical grating pattern) and auditory (modulated tone) stimulation which varied in temporal frequency (4 and 6Hz), and during rest. 

This dataset includes the EEG raw data related to the paper entitled Chamanzar, Haigh, Grover, and Behrmann (2020), "Abnormalities in cortical pattern of coherence in migraine detected using ultra high-density EEG". The link to our paper will be made available as soon as it is published online.

#
# Authors: Include contact information for at least the 
# first author and corresponding author (if not the same), 
# specifically email address, phone number (optional, but preferred), and institution. 
# Contact information for all authors is preferred.
#

2. Author Information

Co-First/Corresponding Author Contact Information
    Name: Alireza Chamanzar
    Institution: Carnegie Mellon University
    Address: Hamerschlag Hall B200, 5000 Forbes Ave., Pittsburgh PA 15213 United States
    Email: achamanz@andrew.cmu.edu
	Phone Number: n/a

Co-First/Corresponding Author Contact Information
    Name: Sarah M Haigh
    Institution: University of Nevada
    Address: 424 Mack Social Sciences, 1664 N. Virginia Street, Reno, NV 89557 United States
    Email: shaigh@unr.edu
	Phone Number: (775) 682-9885

Second/Corresponding Author Contact Information
    Name: Pulkit Grover
    Institution: Carnegie Mellon University
    Address: Hamerschlag Hall B202, 5000 Forbes Ave., Pittsburgh PA 15213 United States
    Email: pgrover@andrew.cmu.edu
	Phone Number: n/a

Third/Corresponding Author Contact Information
    Name: Marlene Behrmann 
    Institution: Carnegie Mellon University
    Address: 331 Baker Hall, 5000 Forbes Ave., Pittsburgh PA 15213 United States
    Email: behrmann@cmu.edu
	Phone Number: n/a



---------------------
DATA & FILE OVERVIEW
---------------------

#
# Directory of Files in Dataset: List and define the different 
# files included in the dataset. This serves as its table of 
# contents. 
#

Directory of Files:

SubID (e.g., M1_1)/ (use EEGLAB toolbox to read these bdf files)

	M1_SSAEP.bdf -> HD-EEG recording of patient M1 during auditory task (SSAEP)
	M1_SSVEP.bdf -> HD-EEG recording of patient M1 during visual task (SSVEP)
	M1resting.bdf -> HD-EEG recording of patient M1 during resting state
	M1aud_migraine.txt -> The response time (in seconds) in the feedback task after auditory stimulation
	M1vis_migraine.txt -> The response time (in seconds) in the feedback task after visual stimulation
	

EEG_Stimuli/ -> a folder containing all of the matlab codes for the visual and auditory stimuli of the EEG recording in this dataset.
		aud_SSAEP.m -> matlab code for the SSAEP stimulation
		vis_SSVEP.m -> matlab code for the SSVEP stimulation
		Resting_migraine.m -> matlab code for the Resting state
		maskandtest_m1.mat -> matlab file containing the SSVEP patterns used in vis_SSVEP.m.
		maskandtest_m2.mat -> matlab file containing the SSVEP patterns used in vis_SSVEP.m.

EEG experiment protocol_Migraine_Brain_KiltHub_vF.pdf -> a document which explains the details of the visual/auditory stimuli, trial structures, and instruction on how to use the stimuli matlab codes. 

Migraine_Control_Demographics.xlsx -> demographic information of the participants in our study. M13 was excluded in our study due to lack of auditory recording, and M2, M6, and M18 were excluded from our analysis because of medication. We only used matched control subjects reported in this file, however there are three more healthy subjects available in this dataset, i.e., C2, C6, and C12.
				
                
Additional Notes on File Relationships, Context, or Content 
(for example, if a user wants to reuse and/or cite your data, 
what information would you want them to know?):    


#
# File Naming Convention: Define your File Naming Convention 
# (FNC), the framework used for naming your files systematically 
# to describe what they contain, which could be combined with the
# Directory of Files. 
#

File Naming Convention:

We have used a unique code for each participant's name to protect the identity of our participants from being discovered by others. "M" in the codes refers to the migraineurs and "C" refers to the control subjects.

#
# Data Description: A data description, dictionary, or codebook
# defines the variables and abbreviations used in a dataset. This
# information can be included in the README file, in a separate 
# file, or as part of the data file. If it is in a separate file
# or in the data file, explain where this information is located
# and ensure that it is accessible without specialized software.
# (We recommend using plain text files or tabular plain text CSV
# files exported from spreadsheet software.) 
#

-----------------------------------------
DATA DESCRIPTION FOR: N/A
-----------------------------------------
<create sections for each dataset included>


1. Number of variables: 


2. Number of cases/rows: 


3. Missing data codes:
        Code/symbol        Definition
        Code/symbol        Definition


4. Variable List

#
# Example. Name: Gender 
#     Description: Gender of respondent
#         1 = Male
#         2 = Female
#         3 = Transgender
#	      4 = Nonbinary
#		  5 = Other gender not listed 
#		  6 = Prefer not to answer
#

    A. Name: <variable name>
       Description: <description of the variable>
                    Value labels if appropriate


    B. Name: <variable name>
       Description: <description of the variable>
                    Value labels if appropriate

--------------------------
METHODOLOGICAL INFORMATION
--------------------------

#
# Software: If specialized software(s) generated your data or
# are necessary to interpret it, please provide for each (if
# applicable): software name, version, system requirements,
# and developer. 
#If you developed the software, please provide (if applicable): 
#A copy of the software’s binary executable compatible with the system requirements described above. 
#A source snapshot or distribution if the source code is not stored in a publicly available online repository.
#All software source components, including pointers to source(s) for third-party components (if any)

1. Software-specific information:
<create a new entry for each qualifying software program>

Name:
Version:
System Requirements:
Open Source? (Y/N): 

(if available and applicable)
Executable URL:
Source Repository URL:
Developer:
Product URL:
Software source components:


Additional Notes(such as, will this software not run on 
certain operating systems?):

#
# Equipment: If specialized equipment generated your data,
# please provide for each (if applicable): equipment name,
# manufacturer, model, and calibration information. Be sure
# to include specialized file format information in the data
# dictionary.
#

2. Equipment-specific information:
N/A

Manufacturer:
Model:

(if applicable)
Embedded Software / Firmware Name:
Embedded Software / Firmware Version:
Additional Notes:

#
# Dates of Data Collection: List the dates and/or times of
# data collection.
#

3. Date of data collection (single date, range, approximate date) <suggested format YYYYMMDD>: Jan 2018-Dec 2018
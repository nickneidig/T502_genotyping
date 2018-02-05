# Bacterial WGS genotyping workflow for BIOT-T502

## Instructions

In today's class (Tuesday the 30th) we will run the first part of our analysis pipeline. To do this we will use the many of the skills that we learned over the previous three class periods. 

To begin, please click on this repository on the github: https://github.com/rtraborn/T502_genotyping . Then, please click 'Fork' on the upper-right-hand side of the page. This will fork this github repo and it attach it to your own personal github account, allowing you to make changes and push them to your own account. 

Now, please navigate to your own personal github page. Under 'repositories', you should see _T502_genotyping_. Please click on it. On the main repository page you should see *<your user ID>*/T502_genotyping in the upper-left-hand corner of the page, and underneath it, in smaller letters, you should see "forked from rtraborn/T502_genotyping" in smaller letters.

Once that checks out we can go head and clone the repository to your home directory on Carbonate. Please use your ssh2 client to login to Carbonate. Then, once you have logged in, please copy the link to your forked repository. It should look something like this: https://github.com/studentID/T502_genotyping (where _studentID_ is your github account username).

Once logged in, now clone the repository to your home directory in Carbonate, and enter the directory as follows:

```
git clone https://github.com/studentID/T502_genotyping
cd T502_genotyping 
```

Now, let's enter the `scripts/` directory: 

```
cd scripts
```

### Running Fastqc on our reads

If type `ls` in our bash interpreter we'll see that there are several scripts in this directory, but let's focus our attention on the one entitled `fastqc_batch.sh`. We can read the contents of the script using by typing `less fastqc_batch.sh`, which we can exit at any time by typing the letter 'q'. As you'll see, this script will make links to the fastq files hosted on Carbonate, and then will complete a [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) run on all of them.

It will be necessary to make a few changes to our repository before we can submit this job to the scheduler. After the PBS header lines, we'll need to specify a output directory.

```
####### Before running the script, please enter path to desired output directory, below ####  
fqDir=<provide path to desired output directory>  
```

Please type `nano fastqc_batch.sh` and use the text editor to enter your desired output directory on Carbonate. The script will not run until you've made this change.

Once you've done this we can submit our Fastqc job to the scheduler.

```
qsub fastqc_batch.sh
```

Once it has passed through the queue the job should take 20-30 minutes to run on Carbonate. Once this is complete please download the results (which will be in .zip format) to your local workstation. Once they are on your computer, uncompress them and double-click on the *.html file inside the folder to view each report. We will go through how to interpret these results together during class.

### Alignment

Now let's proceed to the alignment, which will be the most computatationally-expensive job we will run in our analysis. We will be taking both reads pairs from all ten (10) isolates and align them to the E. coli genome. Of course, this will require that we also download the genome assembly. I have put together everything we'll need for this job, including a script (found in `./0README`) that automatically downloads the assembly and annotation. The aligner software we will use is called bwa (Li and Durbin, 2013). The documentation for bwa can be found here: http://bio-bwa.sourceforge.net/bwa.shtml. I have chosen to run bwa because of its reliability for genotyping projects. Fortunately, this software is installed as a module in Carbonate, so we can invoke it easily in our batch script (`module load bwa` to be precise) without having to install it ourselves.

Before we begin, make sure that you've commited the changes that you've already made in your repository. It's important that you stage (add), commit and push all of your updated files (especially the fastqc script) before proceeding. Assuming you are in this directory, please type:

```
git status #see list of updated files
git add <path to file(s) to add> #replace everything after "add" with path(s) to the file(s) in your repo that you want to track (*not* fastq files!). 
git commit -m "Compose a descriptive commit message."
put push origin master
```

Great. Now that this is complete you'll need to pull from this (i.e. my) repository, as I've added a few important updates to the workflow (and to this document also!). 

``` 
## assuming you are still in the workflow directory:
git pull https://github.com/rtraborn/T502_genotyping master
```

It may try to do a 'merge' on some of your recently-changed files. If it does this you'll need to select which of the two versions of a file to keep. In the case of the `fastqc_batch.sh` script, choose your changes. Everything else should go through ok, and it will sync my recent updates. To exit from the vim page that may appear during the merge process, type `:wq`.

First, let's automatically download the assembly and annotation files.

```
source 0README
## this will initiate download of the necessary files to this repository.
ls 
```

Next, please move into the `scripts/` directory and edit the file using your favorite text editor.

```
## assuming you use nano
nano align_bwa.sh
```

Please make the necessary changes to the following lines:
```
WD=</path/to/Carbonate/T502_genotyping/>
```

Once we've checked over the script and added the correct path to the line beginning in `WD=`, then we can submit our job to the scheduler.

```
#assuming we're in scripts/
qsub align_bwa.sh
```

Log back into Carbonate periodically to check on the status of your job as follows:

```
qstat -u yourID
```

If a job terminates prematuresly, please look at the error file (e.g. `PP_RNAseq_STAR_align_T502.e109469`) in your scripts directory, which will give you clues as to why the job halted.

```
### your error file name will be slighly different- this is just an example.
less .e109469 
```

Once your job is complete, you should have 10 BAM files in the `alignments/` directory. You can look at them using a module called samtools.

```
cd alignments
module load samtools
samtools view NHR40-2.R1.bam | less
## that should open a window in your terminal that allows you to explore the alignments using your cursor.
## exit by typing the letter 'q' at any time.
```

See you on Thursday!
#!/bin/bash

#PBS -N WGS_genotyping_align_T502
#PBS -k o
#PBS -l nodes=1:ppn=16,vmem=80gb
#PBS -l walltime=3:00:00
#PBS -m abe

module load star

fileDir=/N/dc2/scratch/rtraborn/T502_fastqs/Genotyping_Ecoli
####### Before running the script, please enter path to desired output directory, below ####
WD=/N/dc2/scratch/rtraborn/T502_genotyping/
#WD=<enter/path/to/T502_genotyping/>
fqDir=fastqs
genomedir=${WD}/fasta
KPgenome=pacificus_Hybrid2.fa
ECIgenome=
ECgenome=
nThreads=16


echo "Starting job"

echo "Making symbolic links to fastq files."

cd $WD

if [ ! -d "$fqDir" ] ; then
    mkdir $fqDir
  fi

cd $fqDir

ln -s ${fileDir}/GSF1659-EC-7_S17_R1_001.fastq.gz EC-7_S17_R1.fastq.gz 
ln -s ${fileDir}/GSF1659-EC-7_S17_R2_001.fastq.gz  EC-7_S17_R2.fastq.gz 
ln -s ${fileDir}/GSF1659-ECL-1_S15_R1_001.fastq.gz ECL-1_S15_R1.fastq.gz
ln -s ${fileDir}/GSF1659-ECL-1_S15_R2_001.fastq.gz ECL-1_S15_R2.fastq.gz
ln -s ${fileDir}/GSF1659-ECL-4_S16_R1_001.fastq.gz ECL-4_S16_R1.fastq.gz
ln -s ${fileDir}/GSF1659-ECL-4_S16_R2_001.fastq.gz ECL-4_S16_R2.fastq.gz
ln -s ${fileDir}/GSF1659-KP-177_S18_R1_001.fastq.gz KP-177_S18_R1.fastq.gz
ln -s ${fileDir}/GSF1659-KP-177_S18_R2_001.fastq.gz KP-177_S18_R2.fastq.gz
ln -s ${fileDir}/GSF1659-KP-49_S9_R1_001.fastq.gz KP-49_S9_R1.fastq.gz
ln -s ${fileDir}/GSF1659-KP-49_S9_R2_001.fastq.gz KP-49_S9_R2.fastq.gz
ln -s ${fileDir}/GSF1659-KP-80_S10_R1_001.fastq.gz KP-80_S10_R1.fastq.gz
ln -s ${fileDir}/GSF1659-KP-80_S10_R2_001.fastq.gz KP-80_S10_R2_001.fastq.gz
ln -s ${fileDir}/GSF1659-KP-83_S11_R1_001.fastq.gz KP-83_S11_R1.fastq.gz 
ln -s ${fileDir}/GSF1659-KP-83_S11_R2_001.fastq.gz KP-83_S11_R2.fastq.gz 
ln -s ${fileDir}/GSF1659-KP-84_S12_R1_001.fastq.gz KP-84_S12_R1.fastq.gz
ln -s ${fileDir}/GSF1659-KP-84_S12_R2_001.fastq.gz KP-84_S12_R2.fastq.gz
ln -s ${fileDir}/GSF1659-KP-86_S14_R1_001.fastq.gz KP-86_S14_R1.fastq.gz
ln -s ${fileDir}/GSF1659-KP-86_S14_R2_001.fastq.gz KP-86_S14_R2.fastq.gz
ln -s ${fileDir}/GSF1659-KP-85_S13_R1_001.fastq.gz KP-85_S13_R1.fastq.gz 
ln -s ${fileDir}/GSF1659-KP-85_S13_R2_001.fastq.gz KP-85_S13_R2.fastq.gz

cd $WD

echo "Retrieving the appropriate assembly files"

source 0README

echo "Performing alignment on the bacterial files"

readconfigfile $configfile

cd $genomedir

  cd ${WD}/${fqDir}
  for file1 in *.R1.fastq.gz; do
    file2=$(basename $file1 .R1.fastq.gz).R2.fastq.gz
    echo "STAR --runMode alignReads --runThreadN $numproc  ${STARalignReadsOptions}  --outSAMtype BAM SortedByCoordinate --outSAMorder Paired  --outFileNamePrefix $(basename $file1 _001.fastq.gz).STAR.  --genomeDir $genomedir  --readFilesIn ${file1} ${file2}"

  done

  cd ${WD}
  if [ ! -d "alignments" ] ; then
    mkdir alignments
  fi
  cd alignments
  for file1 in ${WD}/$fqDir/*.STAR.*.bam ; do
    echo $file1
    file2=$(basename $file1)
    echo $file2
    ln -s $file1 ./${file2/.STAR.Aligned.sortedByCoord.out}
  done
  cd ..

  echo ""
  echo " Done with step 3 (read mapping)."
  echo ""
  echo "================================================================================"
fi


exit



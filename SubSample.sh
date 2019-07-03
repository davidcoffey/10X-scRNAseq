# Define universal variables
export ROOT="/fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619"
export SCRATCH="/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/"
export SEQTK="~/Apps/seqtk/seqtk"
export GE_REFERENCE="/shared/silo_researcher/Warren_E/ngs/ReferenceGenomes/Human_genomes/refdata-cellranger-hg19-3.0.0"
export SUBSAMPLES="0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1"

mkdir -p $SCRATCH/SubSample/Logs

# Subsample fastq files
for S in ${SUBSAMPLES}; do
  mkdir -p $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L001_I1_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq"
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L001_R1_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq"
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L001_R2_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq"
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L002_I1_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq"
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L002_R1_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq"
  sbatch -n 1 -c 4 -t 1-0 --output=$SCRATCH/SubSample/Logs/333224_6P_1_S4_L002_R2_001_SUB${S}.log --wrap="$SEQTK sample -s100 $ROOT/FASTQ/GE/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq.gz ${S} > $SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq"
done

export FILES="
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.8/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.4/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.9/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.3/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.5/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.1/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.7/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.2/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_R1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_R2_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L001_I1_001.fastq
/fh/scratch/delete30/warren_h/dcoffey/scRNAseq/10X041619/SubSample/FASTQ/GE/SUBSAMPLE0.6/H7273DRXX/333224_6P_1/333224_6P_1_S4_L002_I1_001.fastq"

for F in ${FILES}; do
    echo ${F}
    sbatch -n 1 -c 4 -t 3-0 --output=$SCRATCH/SubSample/Logs/gzip.log --wrap="gzip ${F}"
done

# Generate single cell gene counts
for S in ${SUBSAMPLES}; do
    echo ${S}
    mkdir -p $SCRATCH/SubSample/Counts/SUBSAMPLE${S}
    cd $SCRATCH/SubSample/Counts/SUBSAMPLE${S}
    export FASTQ_DIRECTORY="$SCRATCH/SubSample/FASTQ/GE/SUBSAMPLE${S}/H7273DRXX"
    export SAMPLE="333224_6P_1"
    sbatch -n 1 -c 4 -t 3-0 --job-name="COUNTS" --output=$SCRATCH/SubSample/Logs/Counts.333224_6P_1_SUB${S}.log /fh/fast/warren_h/users/dcoffey/scRNAseq/10X041619/Scripts/Counts.sh
done

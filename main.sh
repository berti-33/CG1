#!/bin/bash

P="/home"
PT=$P"/tools"
PO=$P"/output"
PI=$P"/input"
PG=$P"/genomes"

Preference=$P"/human_g1k_v37.fasta"
PControl=$PG"/Control.bam"
PCancer=$PG"/Cancer.bam"
PTumor=$PG"/Tumor.bam"
PSortedControl=$PG"/Control.sorted.bam"
PSortedTumor=$PG"/Tumor.sorted.bam"
PRealignedControl=$PG"/Control.sorted.realigned.bam"
PRealignedTumor=$PG"/Tumor.sorted.realigned.bam"
PRealignedRecalibratedControl=$PG"/Control.sorted.realigned.recalibrated.bam"
PRealignedRecalibratedTumor=$PG"/Tumor.sorted.realigned.recalibrated.bam"
PRealignedRecalibratedDedupControl=$PG"/Control.sorted.realigned.recalibrated.dedup.bam"
PRealignedRecalibratedDedupTumor=$PG"/Tumor.sorted.realigned.recalibrated.dedup.bam"
SampleDataBase=hg19kg
PpileupControl=$PO"/Control.pileup"
PpileupTumor=$PO"/Tumor.pileup"

Pcancergenesels=$PI"/CancerGenesSel.bed"
Pcaturedregions=$PI"/Captured_Regions.bed"
Phapmap=$PI"/hapmap_3.3.b37.vcf"
PclinvarPathogenic=$PI"/clinvar_Pathogenic.vcf"

#wget https://download.java.net/java/GA/jdk8/latest/binaries/openjdk-8u412-b08-linux-x64.tar.gz
Pjava=$PT"/jdk8u492-b09/bin/java"
Pjava=java

#tar -xjf samtools-1.21.tar.bz2
#cd samtools-1.21
#./configure --prefix=$HOME/.local
#make
#make install
Psamtools=$PT"/samtools-1.21/samtools"

PGATK38=$PT"/GenomeAnalysisTK.jar"
GATK38="$Pjava -jar $PGATK38 -T"
RealignerTargetCreator="$GATK38 RealignerTargetCreator"
IndelRealigner="$GATK38 IndelRealigner"
BaseRecalibrator="$GATK38 BaseRecalibrator"
PrintReads="$GATK38 PrintReads"
AnalyzeCovariates="$GATK38 AnalyzeCovariates"
UnifiedGenotyper="$GATK38 UnifiedGenotyper"
ASEReadCounter="$GATK38 ASEReadCounter"

#tar -xjf bcftools-1.21.tar.bz2
#cd bcftools-1.21
#make
Pbcftools=$PT"/bcftools-1.21/bcftools"

#unzip vcftools-vcftools-0.1.17-1-g1f87a83.zip
#cd vcftools-vcftools-1f87a83
#./autogen.sh
#./configure --prefix=$HOME/.local
#make
#make install
Pvcftools=$PT"/vcftools-vcftools-1f87a83/src/cpp/vcftools"

PsnpEff=$PT"/snpEff.jar"
snpEff="$Pjava -Xmx4g -jar $PsnpEff"

PsnpSift=$PT"/SnpSift.jar"
snpSift="$Pjava -Xmx4g -jar $PsnpSift"

PVarScan=$PT"/VarScan.v2.3.9.jar"
varScan="$Pjava -jar $PVarScan"

Ppicard=$PT"/picard.jar"
picard="$Pjava -jar $Ppicard"
MarkDuplicates="$picard MarkDuplicates"

PCBS=$PT"/CBS.R"

PCLONET=$PT"/step.R"

PrelignerIntervals=$PO"/realigner.intervals"
PrealignerIntervalsControl=$PO"/realignerControl.intervals"
PrealignerIntervalsTumor=$PO"/realignerTumor.intervals"
PrecaltableControl=$PO"/recalControl.table"
PrecaltableTumor=$PO"/recalTumor.table"
PafterRecalTableControl=$PO"/afterRecalControl.table"
PafterRecalTableTumor=$PO"/afterRecalTumor.table"
PrecalCSVControl=$PO"/recalControl.csv"
PrecalCSVTumor=$PO"/recalTumor.csv"
PrecalPlotControl=$PO"/recalControl.pdf"
PrecalPlotTumor=$PO"/recalTumor.pdf"
PmetricsFileControl=$PO"/metricsControl.log"
PmetricsFileTumor=$PO"/metricsTumor.log"
PbcgvcfControl=$PO"/bcf.Control.vcf"
PbcgvcfTumor=$PO"/bcf.Tumor.vcf"
PgatkvcfControl=$PO"/gatk.Control.vcf"
PgatkvcfTumor=$PO"/gatk.Tumor.vcf"
PbcfControl=$PO"/bcf.Control"
PbcfTumor=$PO"/bcf.Tumor"
PgatkControl=$PO"/gatk.Control"
PgatkTumor=$PO"/gatk.Tumor"
PbcfRecodeAnnHtmlControl=$PO"/bcf.Control.recode.ann.html"
PbcfRecodeAnnHtmlTumor=$PO"/bcf.Tumor.recode.ann.html"
PgatkRecodeAnnHtmlControl=$PO"/gatk.Control.recode.ann.html"
PgatkRecodeAnnHtmlTumor=$PO"/gatk.Tumor.recode.ann.html"
PbcfRecodeAnnVcfControl=$PO"/bcf.Control.recode.ann.vcf"
PbcfRecodeAnnVcfTumor=$PO"/bcf.Tumor.recode.ann.vcf"
PgatkRecodeAnnVcfControl=$PO"/gatk.Control.recode.ann.vcf"
PgatkRecodeAnnVcfTumor=$PO"/gatk.Tumor.recode.ann.vcf"
PbcfRecodeAnn2vcfControl=$PO"/bcf.Control.recode.ann2.vcf"
PbcfRecodeAnn2vcfTumor=$PO"/bcf.Tumor.recode.ann2.vcf"
PgatkRecodeAnn2vcfControl=$PO"/gatk.Control.recode.ann2.vcf"
PgatkRecodeAnn2vcfTumor=$PO"/gatk.Tumor.recode.ann2.vcf"
PbcfRecodeAnn3vcfControl=$PO"/bcf.Control.recode.ann3.vcf"
PbcfRecodeAnn3vcfTumor=$PO"/bcf.Tumor.recode.ann3.vcf"
PgatkRecodeAnn3vcfControl=$PO"/gatk.Control.recode.ann3.vcf"
PgatkRecodeAnn3vcfTumor=$PO"/gatk.Tumor.recode.ann3.vcf"
PsomaticSNP=$PO"/somatic.pm"
PsomaticIndel=$PO"/somatic.indel"
PsomaticSNPAnn=$PO"/somatic.pm.ann.vcf"
PsomaticSNPAnnClinvar=$PO"/somatic.pm.ann.clinvar.vcf"
PsomaticCNA=$PO"/somatic.cna"
PhetvcfControl=$PO"/Control.het.vcf"
PaseReadControl=$PO"/ASEreadControl.csv"
PaseReadTumor=$PO"/ASEreadTumor.csv"

#sort and index
$Psamtools sort $PControl > $PSortedControl
$Psamtools sort $PTumor > $PSortedTumor

$Psamtools index $PSortedControl
$Psamtools index $PSortedTumor

#realignment
$RealignerTargetCreator -R $Preference -I $PSortedControl -o $PrealignerIntervalsControl -L $Pcaturedregions
$RealignerTargetCreator -R $Preference -I $PSortedTumor -o $PrealignerIntervalsTumor -L $Pcaturedregions

$IndelRealigner -R $Preference -I $PSortedControl -targetIntervals $PrealignerIntervalsControl -o $PRealignedControl -L $Pcaturedregions
$IndelRealigner -R $Preference -I $PSortedTumor -targetIntervals $PrealignerIntervalsTumor -o $PRealignedTumor -L $Pcaturedregions

$Psamtools view $PRealignedControl | grep OC | wc -ll
$Psamtools view $PRealignedTumor | grep OC | wc -ll

#recalibration
$BaseRecalibrator -R $Preference -I $PRealignedControl -knownSites $Phapmap -o $PrecaltableControl -L $Pcaturedregions
$BaseRecalibrator -R $Preference -I $PRealignedTumor -knownSites $Phapmap -o $PrecaltableTumor -L $Pcaturedregions

$PrintReads -R $Preference -I $PRealignedControl -BQSR $PrecaltableControl -o $PRealignedRecalibratedControl -L $Pcaturedregions --emit_original_quals
$PrintReads -R $Preference -I $PRealignedTumor -BQSR $PrecaltableTumor -o $PRealignedRecalibratedTumor -L $Pcaturedregions --emit_original_quals

$BaseRecalibrator -R $Preference -I $PRealignedControl -knownSites $Phapmap -BQSR $PrecaltableControl -o $PafterRecalTableControl -L $Pcaturedregions
$BaseRecalibrator -R $Preference -I $PRealignedTumor -knownSites $Phapmap -BQSR $PrecaltableTumor -o $PafterRecalTableTumor -L $Pcaturedregions

$AnalyzeCovariates -R $Preference -before $PrecaltableControl -after $PafterRecalTableControl -csv $PrecalCSVControl -plots $PrecalPlotControl
$AnalyzeCovariates -R $Preference -before $PrecaltableTumor -after $PafterRecalTableTumor -csv $PrecalCSVTumor -plots $PrecalPlotTumor

$Psamtools view $PRealignedRecalibratedControl | grep OQ | wc -l
$Psamtools view $PRealignedRecalibratedTumor | grep OQ | wc -l

#deduplication
$MarkDuplicates I=$PRealignedRecalibratedControl O=$PRealignedRecalibratedDedupControl REMOVE_DUPLICATES=true TMP_DIR=$P"/tmpDir" METRICS_FILE=$PmetricsFileControl ASSUME_SORTED=true
$MarkDuplicates I=$PRealignedRecalibratedTumor O=$PRealignedRecalibratedDedupTumor REMOVE_DUPLICATES=true TMP_DIR=$P"/tmpDir" METRICS_FILE=$PmetricsFileTumor ASSUME_SORTED=true

#variant calling -
$Pbcftools mpileup -Ou -a DP -f $Preference $PRealignedRecalibratedDedupControl | $Pbcftools call -Ov -c -v > $PbcgvcfControl
#$Pbcftools mpileup -Ou -a DP -f $Preference $PRealignedRecalibratedDedupTumor | $Pbcftools call -Ov -c -v > $PbcgvcfTumor

$Psamtools index $PRealignedRecalibratedDedupControl
#$Psamtools index $PRealignedRecalibratedDedupTumor

$UnifiedGenotyper -R $Preference -I $PRealignedRecalibratedDedupControl -o $PgatkvcfControl -L $Pcaturedregions
#$UnifiedGenotyper -R $Preference -I $PRealignedRecalibratedDedupTumor -o $PgatkvcfTumor -L $Pcaturedregions

$Pvcftools --minQ 20 --max-meanDP 200 --min-meanDP 5 --remove-indels --vcf $PbcgvcfControl --out $PbcfControl --recode --recode-INFO-all
#$Pvcftools --minQ 20 --max-meanDP 200 --min-meanDP 5 --remove-indels --vcf $PbcgvcfTumor --out $PbcfTumor --recode --recode-INFO-all

$Pvcftools --minQ 20 --max-meanDP 200 --min-meanDP 5 --remove-indels --vcf $PgatkvcfControl --out $PgatkControl --recode --recode-INFO-all
#$Pvcftools --minQ 20 --max-meanDP 200 --min-meanDP 5 --remove-indels --vcf $PgatkvcfTumor --out $PgatkTumor --recode --recode-INFO-all

$Pvcftools --vcf $PbcfControl.recode.vcf --diff $PgatkControl.recode.vcf --diff-site
$Pvcftools --vcf $PbcfTumor.recode.vcf --diff $PgatkTumor.recode.vcf --diff-site

#variant annotation
$snpEff -v $SampleDataBase $PbcfControl.recode.vcf -s $PbcfRecodeAnnHtmlControl > $PbcfRecodeAnnVcfControl
$snpEff -v $SampleDataBase $PbcfTumor.recode.vcf -s $PbcfRecodeAnnHtmlTumor > $PbcfRecodeAnnVcfTumor

$snpSift Annotate $Phapmap $PbcfRecodeAnnVcfControl > $PbcfRecodeAnn2vcfControl
$snpSift Annotate $Phapmap $PbcfRecodeAnnVcfTumor > $PbcfRecodeAnn2vcfTumor

$snpSift Annotate $PclinvarPathogenic $PbcfRecodeAnn2vcfControl > $PbcfRecodeAnn3vcfControl
$snpSift Annotate $PclinvarPathogenic $PbcfRecodeAnn2vcfTumor > $PbcfRecodeAnn3vcfTumor

$snpEff -v $SampleDataBase $PgatkControl.recode.vcf -s $PgatkRecodeAnnHtmlControl > $PgatkRecodeAnnVcfControl
$snpEff -v $SampleDataBase $PgatkTumor.recode.vcf -s $PgatkRecodeAnnHtmlTumor > $PgatkRecodeAnnVcfTumor

$snpSift Annotate $Phapmap $PgatkRecodeAnnVcfControl > $PgatkRecodeAnn2vcfControl
$snpSift Annotate $Phapmap $PgatkRecodeAnnVcfTumor > $PgatkRecodeAnn2vcfTumor

$snpSift Annotate $PclinvarPathogenic $PgatkRecodeAnn2vcfControl > $PgatkRecodeAnn3vcfControl
$snpSift Annotate $PclinvarPathogenic $PgatkRecodeAnn2vcfTumor > $PgatkRecodeAnn3vcfTumor

filter

#somatic variant calling
$Psamtools mpileup -q 1 -f $Preference $PRealignedRecalibratedDedupControl > $PpileupControl
$Psamtools mpileup -q 1 -f $Preference $PRealignedRecalibratedDedupTumor > $PpileupTumor

$varScan somatic $PpileupControl $PpileupTumor --output-snp $PsomaticSNP --output-indel $PsomaticIndel --output-vcf 1

$snpSift Annotate $Phapmap $PsomaticSNP.vcf > $PsomaticSNPAnn.vcf
$snpSift Annotate $PclinvarPathogenic $PsomaticSNPAnn.vcf > $PsomaticSNPAnnClinvar.vcf


filter

#somatic copy number
$Psamtools mpileup -q 1 -f $Preference $PRealignedRecalibratedDedupControl $PRealignedRecalibratedDedupTumor | $varScan copynumber --output-file $PsomaticCNA --mpileup 1

$varScan copyCaller $PsomaticCNA.copynumber --output-file $PsomaticCNA.called

Rscript $PCBS $PsomaticCNA.called $PO"/SegPlot.pdf" $PsomaticCNA.called.seg $PO"/library"

#purity and poloidy estimation
grep -E "(^#|0/1)" $PbcgvcfControl > $PhetvcfControl
$Pbcftools view -v snps -m2 -M2 -g het $PbcgvcfControl -Ov -o $PhetvcfControl

#15	43170690	.	TACACACACACACACACACACACACACACACACACAC	TACACACACACACACACACACACACACACACACACACAC	25.4782	.	INDEL;IDV=3;IMF=0.1875;DP=16;VDB=0.343065;SGB=-0.556411;RPBZ=-0.73994;MQBZ=0;MQSBZ=0;BQBZ=-1.00554;SCBZ=-0.480384;MQ0F=0;AF1=0.5;AC1=1;DP4=9,2,4,0;MQ=60;FQ=28.482;PV4=1,1,1,1	GT:PL:DP:AD	0/1:63,0,147:15:11,3

$ASEReadCounter -R $Preference -o $PaseReadControl -I $PRealignedRecalibratedDedupControl -sites $PhetvcfControl -U ALLOW_N_CIGAR_READS -minDepth 20 --minMappingQuality 20 --minBaseQuality 20
$ASEReadCounter -R $Preference -o $PaseReadTumor -I $PRealignedRecalibratedDedupTumor -sites $PhetvcfControl -U ALLOW_N_CIGAR_READS -minDepth 20 --minMappingQuality 20 --minBaseQuality 20

Rscript $PCLONET $PO $PsomaticCNA.called.seg $PaseReadControl $PaseReadTumor $PsomaticSNP.vcf $PO"/library"

#filter annotation

filter="((exists ID) & (ANN[ANY].IMPACT = 'HIGH') & (exists CLNSIG))"
info="POS ID ANN[ANY].GENE"
PgermilineAnnFilteredControlBcf=$PO"/germlineAnnFilteredControlBcf.vcf"
PgermilineAnnFilteredControlGATK=$PO"/germlineAnnFilteredControlGATK.vcf"
PgermilineAnnFilteredControlBcfR=$PO"/germlineAnnFilteredControlBcfR.vcf"
PgermilineAnnFilteredControlGATKR=$PO"/germlineAnnFilteredControlGATKR.vcf"
cat $PbcfRecodeAnn3vcfControl | $snpSift filter "$filter" > $PgermilineAnnFilteredControlBcf
cat $PgatkRecodeAnn3vcfControl | $snpSift filter "$filter" > $PgermilineAnnFilteredControlGATK
$snpSift extractFields $PgermilineAnnFilteredControlBcf $info > $PgermilineAnnFilteredControlBcfR
$snpSift extractFields $PgermilineAnnFilteredControlGATK $info > $PgermilineAnnFilteredControlGATKR

#count variants found
grep -vc "^#" $PbcgvcfControl
#!/usr/bin/perl

# README
# 
# This script uses WWW::Mechanize to get siRNAs from siDirect 2.0 web server (http://siDirect2.RNAi.jp/).
# WWW::Mechanize module is available at CPAN.
#
# Usage:
# ./siDirect2crawl.pl  sequence.txt
#
# sequence.txt is a single FASTA file or a plain nucleotide sequence file (i.e., only contains nucleotide sequence).
# Characters other than A,T,G,C and U are ignored. Both lower-case and upper-case letters are accepted.
#
# ========== Example of sequence.txt ==========
# ggctgccaag aacctgcagg aggcagaaga atggtacaaa tccaagtttg ctgacctctc
# tgaggctgcc aaccggaaca atgacgccct gcgccaggca aagcaggagt ccactgagta
# ccggagacag gtgcagtccc tcacctgtga agtggatgcc cttaaaggaa ccaatgagtc
# cctggaacgc cagatgcgtg aaatggaaga gaactttgcc gttgaagctg ctaactacca
# agacactatt ggccgcctgc aggatgagat tcagaatatg aaggaggaaa tggctcgtca
# ccttcgtgaa taccaagacc tgctcaatgt taagatggcc cttgacattg agattgccac
# ctacaggaag ctgctggaag gcgaggagag caggatttct ctgcctcttc caaacttttc
# ctccctgaac ctgagggaaa ctaatctgga ttcactccct ctggttgata cccactcaaa
# aaggacactt ctgattaaga cggttgaaac tagagatgga caggttatca acgaaacttc
# tcagcatcac gatgaccttg aataaaaatt gcacacactc agtgcagcaa tatattacca
# ========================================
#
# If you plan to submit a large number of queries, please insert 'sleep' command to prevent overloading our server.
#
# Example:
# % ls
# input_sequences/     siDirect2crawl.pl*     siDirect_result/
# % cd  input_sequences/
# % ls
# NM_000014.fa     NM_000015.fa     NM_000016.fa   [...]
# % foreach  n  ( * )
# % ../siDirect2crawl.pl  $n >  ../siDirect_result/$n.siRNA
# % sleep  5
# % end
# [...]
# % cd ../siDirect_result/
# % ls
# NM_000014.fa.siRNA     NM_000015.fa.siRNA     NM_000016.fa.siRNA   [...]
#
# Options:
# siRNA design options can be set using %param. All of the parameters are described in the code below.
#
# Example 1)  Parameters for designing human siRNAs:
# my %param = (
# 	'yourSeq' => $input_seq,  # input nucleotide sequence into TEXTAREA.
# 	'uitei' => '1',  # tick the checkbox 'Ui-Tei et al.'
# 	'seedTm' => '1',  # tick the checkbox 'Seed-duplex stability:'
# 	'seedTmMax' => '21.5',  # set 'Max tm' to 21.5 deg C
# 	'spe' => 'hs',  # select 'Homo sapiens' from 'Specificity check:'
# 	'hidenonspe' => '1',  # tick the checkbox 'Hide less-specific siRNAs'
# ) ;
#
# Example 2)  Parameters for designing human shRNA vectors with pol III promoter:
# my %param = (
# 	'yourSeq' => $input_seq,  # input nucleotide sequence into TEXTAREA.
# 	'uitei' => '1',  # tick the checkbox 'Ui-Tei et al.'
# 	'seedTm' => '1',  # tick the checkbox 'Seed-duplex stability:'
# 	'seedTmMax' => '21.5',  # set 'Max tm' to 21.5 deg C
# 	'spe' => 'hs',  # select 'Homo sapiens' from 'Specificity check:'
# 	'hidenonspe' => '1',  # tick the checkbox 'Hide less-specific siRNAs'
#	'consAT' => '1',  # tick the checkbox "Avoid contiguous A's or T's"
#	'consATmax' => '4',  # Avoid contiguous A's or T's 4 nt or more
#	'custom' => '1',  # tick the checkbox 'Custom pattern:'
#	'customPattern' => 'NNGNNNNNNNNNNNNNNNNNNNN',  # set Custom pattern
#	'hide' => '1',  # tick the checkbox 'Only show siRNAs that match all checked criteria'
# ) ;
#
#
# 2011-06-20  Written by Yuki Naito at Database Center for Life Science (DBCLS), Japan.
#

use warnings ;
use strict ;
use WWW::Mechanize ;

my $input_seq = join '', <> ;

my %param = (
	'yourSeq' => $input_seq,  # input nucleotide sequence into TEXTAREA.
	'uitei' => '1',  # tick the checkbox 'Ui-Tei et al.'
#	'reynolds' => '1',  # tick the checkbox 'Reynolds et al.'
#	'amarzguioui' => '1',  # tick the checkbox 'Amarzguioui et al.'
#	'UorRorA' => '1',  # tick the checkbox 'Ui-Tei + Reynolds + Amarzguioui'
#	'UorRA' => '1',  # tick the checkbox 'Ui-Tei + Reynolds * Amarzguioui'
#	'URA' => '1',  # tick the checkbox 'Ui-Tei * Reynolds * Amarzguioui'
	'seedTm' => '1',  # tick the checkbox 'Seed-duplex stability:'
	'seedTmMax' => '21.5',  # set 'Max tm' to 21.5 deg C
#	'spe' => 'none',  # select 'none' from 'Specificity check:'
	'spe' => 'hs',  # select 'Homo sapiens' from 'Specificity check:'
#	'spe' => 'mm',  # select 'Mus musculus' from 'Specificity check:'
#	'spe' => 'rn',  # select 'Rattus norvegicus' from 'Specificity check:'
	'hidenonspe' => '1',  # tick the checkbox 'Hide less-specific siRNAs'
#	'hitcount' => '1',  # tick the checkbox 'Show number of off-target hits within three mismatches'
#	'pos' => '1',  # tick the checkbox 'Target range:'
#	'posStart' => '1',  # set start position to 1
#	'posEnd' => '100',  # set end position to 100
#	'consGC' => '1',  # tick the checkbox "Avoid contiguous G's or C's"
#	'consGCmax' => '4',  # Avoid contiguous G's or C's 4 nt or more
#	'consAT' => '1',  # tick the checkbox "Avoid contiguous A's or T's"
#	'consATmax' => '4',  # Avoid contiguous A's or T's 4 nt or more
#	'percentGC' => '1',  # tick the checkbox 'GC content:'
#	'percentGCMin' => '0',  # set minimum GC content to 0%
#	'percentGCMax' => '100',  # set maximum GC content to 100%
#	'custom' => '1',  # tick the checkbox 'Custom pattern:'
#	'customPattern' => 'NNGNNNNNNNNNNNNNNNNNNNN',  # set Custom pattern
#	'exclude' => '1',  # tick the checkbox 'Exclude pattern:'
#	'excludePattern' => '',  # set Exclude pattern
#	'hide' => '1',  # tick the checkbox 'Only show siRNAs that match all checked criteria'
#	'ALL' => '1',  # DEBUG MODE; show all siRNAs
) ;

my $html = crawl_siDirect2(%param) ;
my $tab_delimited_result = parse_result_html($html) ;
print $tab_delimited_result ;

exit ;

# ====================
sub crawl_siDirect2 {
my %param = @_ ;
my $mech = WWW::Mechanize->new ;
$mech->get('http://sidirect2.rnai.jp/') ;
$mech->form_name('siDirect') ;
$mech->set_fields(%param) ;
$mech->submit ;
my $html = $mech->content ;
return $html ;
} ;
# ====================
sub parse_result_html {
my $html = $_[0] || '' ;
if ($html =~ /<textarea.*?>\n(.*?)<\/textarea>/is){
	return $1 ;
} else {
	return "Error: cannot retrieve siDirect 2.0 result.\n" ;
}
} ;
# ====================

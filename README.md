siDirect2crawl.pl
======================

This script uses WWW::Mechanize to get siRNAs from
[siDirect 2.0](http://siDirect2.RNAi.jp/) web server.  
WWW::Mechanize module is available at CPAN.

### Usage ###

	% ./siDirect2crawl.pl  sequence.txt

sequence.txt is a single FASTA file or a plain nucleotide sequence file 
(i.e., only contains nucleotide sequence). Characters other than A,T,G,C 
and U are ignored. Both lower-case and upper-case letters are accepted.

### Example of sequence.txt ###

	ggctgccaag aacctgcagg aggcagaaga atggtacaaa tccaagtttg ctgacctctc
	tgaggctgcc aaccggaaca atgacgccct gcgccaggca aagcaggagt ccactgagta
	ccggagacag gtgcagtccc tcacctgtga agtggatgcc cttaaaggaa ccaatgagtc
	cctggaacgc cagatgcgtg aaatggaaga gaactttgcc gttgaagctg ctaactacca
	agacactatt ggccgcctgc aggatgagat tcagaatatg aaggaggaaa tggctcgtca
	ccttcgtgaa taccaagacc tgctcaatgt taagatggcc cttgacattg agattgccac
	ctacaggaag ctgctggaag gcgaggagag caggatttct ctgcctcttc caaacttttc
	ctccctgaac ctgagggaaa ctaatctgga ttcactccct ctggttgata cccactcaaa
	aaggacactt ctgattaaga cggttgaaac tagagatgga caggttatca acgaaacttc
	tcagcatcac gatgaccttg aataaaaatt gcacacactc agtgcagcaa tatattacca

If you plan to submit a large number of queries, please insert 'sleep' 
command to prevent overloading our server.

### Example ###

	% ls
	input_sequences/     siDirect2crawl.pl*     siDirect_result/
	% cd  input_sequences/
	% ls
	NM_000014.fa     NM_000015.fa     NM_000016.fa   [...]
	% foreach  n  ( * )
	% ../siDirect2crawl.pl  $n >  ../siDirect_result/$n.siRNA
	% sleep  5
	% end
	[...]
	% cd ../siDirect_result/
	% ls
	NM_000014.fa.siRNA     NM_000015.fa.siRNA     NM_000016.fa.siRNA   [...]

### Options ###

siRNA design options can be set using ```%param```. 
All of the parameters are described in the code.

![parameters](http://data.dbcls.jp/~meso/img/siDirect2crawl_options.png
"siDirect 2.0 parameters")

**Example 1.**
Parameters for designing human siRNAs:

	my %param = (
		'yourSeq'    => $input_seq,  # input nucleotide sequence into TEXTAREA.
		'uitei'      => '1',         # tick the checkbox 'Ui-Tei et al.'
		'seedTm'     => '1',         # tick the checkbox 'Seed-duplex stability:'
		'seedTmMax'  => '21.5',      # set 'Max tm' to 21.5 deg C
		'spe'        => 'hs',        # select 'Homo sapiens' from 'Specificity check:'
		'hidenonspe' => '1',         # tick the checkbox 'Hide less-specific siRNAs'
	) ;

**Example 2.**
Parameters for designing human shRNA vectors with pol III promoter:

	my %param = (
		'yourSeq'       => $input_seq,  # input nucleotide sequence into TEXTAREA.
		'uitei'         => '1',         # tick the checkbox 'Ui-Tei et al.'
		'seedTm'        => '1',         # tick the checkbox 'Seed-duplex stability:'
		'seedTmMax'     => '21.5',      # set 'Max tm' to 21.5 deg C
		'spe'           => 'hs',        # select 'Homo sapiens' from 'Specificity check:'
		'hidenonspe'    => '1',         # tick the checkbox 'Hide less-specific siRNAs'
		'consAT'        => '1',         # tick the checkbox "Avoid contiguous A's or T's"
		'consATmax'     => '4',         # Avoid contiguous A's or T's 4 nt or more
		'custom'        => '1',         # tick the checkbox 'Custom pattern:'
		'customPattern' => 'NNGNNNNNNNNNNNNNNNNNNNN',  # set Custom pattern
		'hide'          => '1',         # tick the checkbox 'Only show siRNAs that match all checked criteria'
	) ;


License
-------

Copyright &copy; 2011 Yuki Naito
 ([@meso_cacase](http://twitter.com/meso_cacase)) at  
Database Center for Life Science (DBCLS), Japan.  
This software is distributed under
[modified BSD license](http://www.opensource.org/licenses/bsd-license.php).

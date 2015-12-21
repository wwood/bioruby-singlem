require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BioSingleM" do
  it "should read a regular OTU table" do
    string = [%w(gene	sample	sequence	num_hits	coverage	taxonomy),
              %w(4.21.ribosomal_protein_S19_rpsS	20100900_E1D.1	TGGAGTCGCGCCAGTGTTATCTTCCCTCAGATGGTAGGGCACACGATTGCAATTCATGAT	1	2.44)+['Root; d__Bacteria; p__Chloroflexi'],
              %w(4.21.ribosomal_protein_S19_rpsS	20100900_E1D.1	TGGTCAAGGGGCTCCATGATCTCTCCGGATTTTGTAGGACAAACCATTGCAGTTTACAAC	1	2.44)+['Root; d__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Rikenellaceae; g__Alistipes']].collect{|e| e.join("\t")}.join("\n")+"\n"
    t = Bio::SingleM::OtuTable.parse_from_standard_otu_table(StringIO.new(string))
    t.otus.length.should == 2
    
    o = t.otus[0]
    o.marker.should == '4.21.ribosomal_protein_S19_rpsS'
    o.sample_name.should == '20100900_E1D.1'
    o.sequence.should == 'TGGAGTCGCGCCAGTGTTATCTTCCCTCAGATGGTAGGGCACACGATTGCAATTCATGAT'
    o.count.should == 1
    o.coverage.should == 2.44
    o.taxonomy.should == 'Root; d__Bacteria; p__Chloroflexi'

    o = t.otus[1]
    o.marker.should == '4.21.ribosomal_protein_S19_rpsS'
    o.sample_name.should == '20100900_E1D.1'
    o.sequence.should == 'TGGTCAAGGGGCTCCATGATCTCTCCGGATTTTGTAGGACAAACCATTGCAGTTTACAAC'
    o.count.should == 1
    o.coverage.should == 2.44
    o.taxonomy.should == 'Root; d__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Rikenellaceae; g__Alistipes'
end

  it 'should read a query OTU table' do
    string = [%w(query_name	query_sequence	divergence	num_hits	sample	marker	hit_sequence	taxonomy),
              %w(unnamed_sequence	GTCGACGTCCAAGGGATCTCGAAGGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAT	4	1	SRR1586296_1	4.08.ribosomal_protein_L3_rplC	GTCGACGTCCAGGGGATATCGAAGGGCCACGGCTTCGCCGGCGGGATCAAGCGCCACAAC)+['Root; d__Bacteria'],
              %w(unnamed_sequence	GTCGACGTCCAAGGGATCTCGAAGGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAT	5	1	SRR1586278_1	4.08.ribosomal_protein_L3_rplC	GTCGACGTGCAGGGCATCTCGAAAGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAC)+['Root; d__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Acidimicrobiales; f__Acidimicrobiaceae']].collect{|e| e.join("\t")}.join("\n")+"\n"

    q = Bio::SingleM::QueryResult.parse(StringIO.new(string))
    q.otus.length.should == 2
    o = q.otus[0]
    o.query_name.should == 'unnamed_sequence'
    o.query_sequence.should == 'GTCGACGTCCAAGGGATCTCGAAGGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAT'
    o.divergence.should == 4
    o.num_hits.should == 1
    o.sample_name.should == 'SRR1586296_1'
    o.marker.should == '4.08.ribosomal_protein_L3_rplC'
    o.hit_sequence.should == 'GTCGACGTCCAGGGGATATCGAAGGGCCACGGCTTCGCCGGCGGGATCAAGCGCCACAAC'
    o.hit_taxonomy.should == 'Root; d__Bacteria'

    o = q.otus[1]
    o.query_name.should == 'unnamed_sequence'
    o.query_sequence.should == 'GTCGACGTCCAAGGGATCTCGAAGGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAT'
    o.divergence.should == 5
    o.num_hits.should == 1
    o.sample_name.should == 'SRR1586278_1'
    o.marker.should == '4.08.ribosomal_protein_L3_rplC'
    o.hit_sequence.should == 'GTCGACGTGCAGGGCATCTCGAAAGGCCACGGCTTCGCCGGCGGCATCAAGCGCCACAAC'
    o.hit_taxonomy.should == 'Root; d__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Acidimicrobiales; f__Acidimicrobiaceae'
  end
end

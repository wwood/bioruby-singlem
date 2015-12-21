require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tempfile'

data_directory = File.join(File.dirname(__FILE__), 'data')

describe "BioSingleM" do
  it "should run pipe" do
    table = Bio::SingleM::Runner.pipe([File.join(data_directory, 'minimal.fa')], {
                                        :threads => 30,
                                        :singlem_packages => [File.join(data_directory, '4.12.ribosomal_protein_L11_rplK.gpkg.spkg')],
                                      })

    table.otus.length.should == 1
    table.otus[0].sequence.should == 'CCTGCAGGTAAAGCGAATCCAGCACCACCAGTTGGTCCAGCATTAGGTCAAGCAGGTGTG'
  end

  it 'should run query' do
    otus = [%w(gene	sample	sequence	num_hits	coverage	taxonomy),
            %w(4.21.ribosomal_protein_S19_rpsS	20100900_E1D.1	AGGAGTCGCGCCAGTGTTATCTTCCCTCAGATGGTAGGGCACACGATTGCAATTCATGAT	1	2.44)+['Root; d__Bacteria; p__Chloroflexi']].collect{|e| e.join("\t")}.join("\n")+"\n"

    otus_object = Bio::SingleM::OtuTable.parse_from_standard_otu_table(StringIO.new(otus))
    results = Bio::SingleM::Runner.query(File.join(data_directory, 'small.sdb'),
                                         :otu_table => otus_object)
    results.otus.length.should == 1
    results.otus[0].hit_sequence.should == 'TGGAGTCGCGCCAGTGTTATCTTCCCTCAGATGGTAGGGCACACGATTGCAATTCATGAT'
  end
end

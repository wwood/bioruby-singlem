require 'bio-commandeer'
require 'csv'

module Bio
  module SingleM
    class Runner
      # Run singlem pipe and return a Bio::SingleM::OtuTable result
      #
      # Options (with same interface as 'singlem pipe'
      # :threads
      # :singlem_packages
      def self.pipe(sequence_files, options={})
        cmd = "singlem pipe --sequences #{sequence_files.collect{|s| s.inspect}.join(' ')} --otu_table /dev/stdout"
        cmd += " --threads #{options[:threads]}" if options[:threads]
        cmd += " --singlem_packages #{options[:singlem_packages].collect{|s| s.inspect}.join(' ')}" if options[:singlem_packages]

        return OtuTable.parse_from_standard_otu_table(
                 StringIO.new(Bio::Commandeer.run(cmd)))
      end

      # Run singlem query with the given OtuTable object, and return a QueryResult object
      #
      # database_path: string path to SingleM database
      #
      # Options:
      # :otu_table: Query using the given OtuTable object
      def self.query(database_path, options)
        cmd = "singlem query --db #{database_path}"
        if options[:sequence]
          cmd += " --query_sequence #{options[:sequence].inspect}"
          return QueryResult.parse(
            StringIO.new(
              Bio::Commandeer.run cmd))
        elsif options[:otu_table]
          Tempfile.open('bio-singlem-query') do |tempfile|
            options[:otu_table].write(tempfile)
            tempfile.close #to flush
            cmd += " --query_otu_table '#{tempfile.path}'"
            return QueryResult.parse(
              StringIO.new(
                Bio::Commandeer.run cmd))
          end
        else
          raise "Either :sequences or :otu_table must be specified"
        end
      end
    end

    class OtuTableEntry
      attr_accessor :marker, :sample_name, :sequence, :count, :coverage, :taxonomy
    end

    class OtuTable
      # Array of strings
      attr_accessor :headers

      # Array of OtuTableEntry objects
      attr_accessor :otus

      # Parse in a standard OTU table from the given open IO object
      def self.parse_from_standard_otu_table(io)
        table = OtuTable.new
        table.otus = []
        csv = CSV.new(io, :headers => true, :col_sep => "\t")
        csv.each do |row|
          raise "Parse exception on line: #{row.inspect}" if row.length < 6
          i = 0
          otu = OtuTableEntry.new
          otu.marker = row[i]; i+=1
          otu.sample_name = row[i]; i+=1
          otu.sequence = row[i]; i+=1
          otu.count = row[i].to_i; i+=1
          otu.coverage = row[i].to_f; i+=1
          otu.taxonomy = row[i]; i+=1
          table.otus.push otu
        end
        table.headers = csv.headers

        return table
      end

      def write(output_io)
        output_io.puts self.headers.join("\t")
        self.otus.each do |otu|

          output_io.puts [:marker, :sample_name, :sequence, :count,
                          :coverage, :taxonomy].collect {|sym|
            otu.send(sym)
          }.join("\t")
        end
      end
    end

    class QueryResultOtu
      attr_accessor :query_name, :query_sequence, :divergence, :num_hits, :sample_name, :marker, :hit_sequence, :hit_taxonomy
    end

    class QueryResult
      attr_accessor :otus

      def self.parse(io)
        result = QueryResult.new
        result.otus = []

        CSV.new(io, :headers=>true, :col_sep => "\t").each do |row|
          raise "Parse exception on this line: #{row.inspect}" if row.length < 8
          otu = QueryResultOtu.new
          i=0
          otu.query_name = row[i]; i+=1
          otu.query_sequence = row[i]; i+=1
          otu.divergence = row[i].to_i; i+=1
          otu.num_hits = row[i].to_i; i+=1
          otu.sample_name = row[i]; i+=1
          otu.marker = row[i]; i+=1
          otu.hit_sequence = row[i]; i+=1
          otu.hit_taxonomy = row[i]
          result.otus.push otu
        end
        return result
      end
    end
  end
end

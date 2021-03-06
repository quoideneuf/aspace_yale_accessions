require 'date'

module YaleAccessionIdGenerator

  @id_0_generator = lambda {|json|
    date = Date.parse(json['accession_date'])
    "#{date.month > 6 ? date.year + 1 : date.year}"
  }


  @id_2_generator = lambda {|json|
    sequence_name = "yale_accession_#{json['id_0']}_#{json['id_1']}"

    seq = Sequence.get(sequence_name)
    seq = Sequence.get(sequence_name) if seq < 1

    seq.to_s.rjust(4, '0')
  }


  def self.id_0_generator
    @id_0_generator
  end


  def self.id_2_generator
    @id_2_generator
  end


  def update_from_json(json, *other_args)
    json[:id_2] = nil

    # don't get a new sequence unless id_0 or id_1 has changed
    if self[:identifier]
      identifier = Identifiers.parse(self[:identifier])
      if [identifier[0], identifier[1]] == [json[:id_0], json[:id_1]]
        json[:id_2] = identifier[2]
      end
    end

    super
  end

end

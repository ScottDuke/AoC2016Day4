class Decoder

  LETTERS = ('a'..'z').to_a
  
  def initialize(input_file)
    @input = input_file
  end

  def run
    sum = 0
    north_pole_sectore_id = nil
    inputs = File.readlines(@input)
    inputs.each do |line|
      encrypted_name, sector_id, checksum = parse_line(line)
      sector_id = sector_id.to_i
      sum += sector_id if checksum == decode(encrypted_name)
      north_pole_sectore_id = sector_id if decrypt(encrypted_name, sector_id) =~ /north\s*pole/i
    end

    "Sum of sector ids: #{sum}\nNorth pole sector id: #{north_pole_sectore_id}" 
  end

  private

  def parse_line(line)
    line.downcase.match(/\A([a-z-]+)(\d+)\s*\[([a-z]+)\]$/).captures
  end
  
  def decode(encrypted_string)
    grouped_chars = encrypted_string.gsub("-","").chars.group_by{ |char| char }
    sorted_chars = grouped_chars.sort_by{ |key,value| [-value.count, key] }
    decoded_checksum = sorted_chars.first(5).flatten.uniq.join
  end

  def decrypt(encrypted_string, times)
    words = []
    encrypted_string.split("-").each do |part|
      decrpted_word = ""
      part.chars.each do |char|
        count = 0
        while count < times
          count += 1
          char = LETTERS[LETTERS.find_index(char) + 1 - LETTERS.size]
        end
        decrpted_word << char
      end
      words << decrpted_word
    end

    words.join(" ")
  end

end

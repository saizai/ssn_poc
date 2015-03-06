class DeathMasterFile < ActiveRecord::Base
  GROUPS = [1, 3, 5, 7, 9, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 2, 4, 6, 8, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99]

  def self.new_from_line line, date = Date.today
    new change_type:        (line[0].blank? ? nil : line[0]),
        ssn:                line[1..9].to_i,
        ssn_an:             line[1..3].to_i,
        ssn_gn:             line[4..5].to_i,
        ssn_sn:             line[6..9].to_i,
        last_name:          (line[10..29].blank? ? nil : line[10..29].strip),
        name_suffix:        (line[30..33].blank? ? nil : line[30..33].strip),
        first_name:         (line[34..48].blank? ? nil : line[34..48].strip),
        middle_name:        (line[49..63].blank? ? nil : line[49..63].strip),
        verify_proof_code:  (line[64].blank? ? nil : line[64]),
        death_date:         sanitize_date(line[65..72]),
        death_month:        (line[65..66].blank? ? nil : line[65..66].to_i),
        death_day:          (line[67..68].blank? ? nil : line[67..68].to_i),
        death_year:         (line[69..72].blank? ? nil : line[69..72].to_i),
        birth_date:         sanitize_date(line[73..80]),
        birth_month:        (line[73..74].blank? ? nil : line[73..74].to_i),
        birth_day:          (line[75..76].blank? ? nil : line[75..76].to_i),
        birth_year:         (line[77..80].blank? ? nil : line[77..80].to_i),
        state_of_residence: (line[81..82].blank? ? nil : line[81..82].strip),
        last_known_zip_residence: (line[83..87].blank? ? nil : line[83..87].strip),
        last_known_zip_payment: (line[88..92].blank? ? nil : line[88..92].strip),
        extra:              (line[93..99].blank? ? nil : line[93..99].strip),
        date:               date
  end

  def self.sanitize_date date
    return nil if date.to_i == 0 || date.blank?

    # Format: MMDDYYYY
    month, day, year = date[0..1].to_i, date[2..3].to_i, date[4..7].to_i
    if day > 28 && month == 2
      day = 28 # meh leap years
      return nil
    elsif year < 1800
      return nil
    elsif (day == 0) || (month == 0)
      return nil
    end

    Date.new(year, month, day) rescue nil
  end

  def self.import_from_file filename, after = 0, date = Date.today
    file = File.open(filename, 'r')
    batch = []
    while line = file.gets
      new_entry = new_from_line(line, date)
      batch << new_entry if new_entry.ssn > after
      if batch.size > 1000
        import batch
        batch = []
      end
    end
    import batch, on_duplicate_key_update: []  # ignore duplicates
    file.close
  end
end

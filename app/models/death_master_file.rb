class DeathMasterFile < ActiveRecord::Base

  DUMMY_SSNS = %w(078051120 111111111 123456789 219099999 999999999) + ('987654320'..'987654329').to_a

  # Order in which ssn_gn are assigned
  GROUPS = [1, 3, 5, 7, 9, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40,
    42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84,
    86, 88, 90, 92, 94, 96, 98, 2, 4, 6, 8, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33,
    35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77,
    79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99]

  # Assignment of ssn_an to states (/ territories / districts / psuedo-areas)
  # NI: Not issued
  # RR: Railroad Board (discontinued July 1, 1963)
  # PI: Philippine Islands (before independence from US, July 4, 1946)
  # EE: Enumeration at Entry
  AREAS = {'NH': [*1..3], 'ME': [*4..7], 'VT': [*8..9], 'MA': [*10..34], 'RI': [*35..39],
    'CT': [*40..49], 'NY': [*50..134], 'NJ': [*135..158], 'PA': [*159..211], 'MD': [*212..220],
    'DE': [*221..222], 'VA': [*223..231], 'NC': [232], 'WV': [*232..236],
    'NI': [*237..246, *587..665, *667..679, *681..699, *750..772],
    'SC': [*247..251], 'GA': [*252..260], 'FL': [*261..267], 'OH': [*268..302],
    'IN': [*303..317], 'IL': [*318..361], 'MI': [*362..386], 'WI': [*387..399],
    'KY': [*400..407], 'TN': [*408..415], 'AL': [*416..424], 'MS': [*425..428],
    'AR': [*429..432], 'LA': [*433..439], 'OK': [*440..448], 'TX': [*449..467],
    'MN': [*468..477], 'IA': [*478..485], 'MO': [*486..500], 'ND': [*501..502],
    'SD': [*503..504], 'NE': [*505..508], 'KS': [*509..515], 'MT': [*516..517],
    'ID': [*518..519], 'WY': [520], 'CO': [*521..524], 'NM': [525, 585],
    'AZ': [*526..527], 'UT': [*528..529], 'NV': [530, 680], 'WA': [*531..539],
    'OR': [*540..544], 'CA': [*545..573], 'AK': [574], 'HI': [*575..576],
    'DC': [*577..579], 'VI': [580], 'PR': [*580..584], 'GU': [586],
    'AS': [586], 'PI': [586], 'RR': [*700..728],
    'EE': [*729..733]
  }

  AN_NAMES = AREAS.inject({}){|h,v| v[1].each{|i| h[i].nil? ? h[i] = v[0].to_s : h[i] += ', ' + v[0].to_s}; h}

  # [:change_type, :ssn_an, :ssn_gn, :ssn_sn, :last_name, :name_suffix,
  #      :first_name, :middle_name, :verify_proof_code, :death_month, :death_day,
  #      :death_year, :birth_month, :birth_day, :birth_year, :state_of_residence,
  #      :last_known_zip_residence, :last_known_zip_payment, :extra, :as_of]
  def self.parse_line_array line, date = Date.today
    [(line[0].blank? ? nil : line[0]), line[1..3].to_i, line[4..5].to_i,
      line[6..9].to_i, (line[10..29].blank? ? nil : line[10..29].strip),
      (line[30..33].blank? ? nil : line[30..33].strip),
      (line[34..48].blank? ? nil : line[34..48].strip),
      (line[49..63].blank? ? nil : line[49..63].strip),
      (line[64].blank? ? nil : line[64]),
      ((line[65..66].blank? || line[65..66].to_i == 0) ? nil : line[65..66].to_i),
      ((line[67..68].blank? || line[67..68].to_i == 0) ? nil : line[67..68].to_i),
      ((line[69..72].blank? || line[69..72].to_i == 0) ? nil : line[69..72].to_i),
      ((line[73..74].blank? || line[73..74].to_i == 0) ? nil : line[73..74].to_i),
      ((line[75..76].blank? || line[75..76].to_i == 0) ? nil : line[75..76].to_i),
      ((line[77..80].blank? || line[77..80].to_i == 0) ? nil : line[77..80].to_i),
      (line[81..82].blank? ? nil : line[81..82].strip),
      (line[83..87].blank? ? nil : line[83..87].strip),
      (line[88..92].blank? ? nil : line[88..92].strip),
      (line[93..99].blank? ? nil : line[93..99].strip), date ]
  end

  def self.import_from_file filename, after = 0, date = Date.today
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    file = File.open(filename, 'r')
    batch = []
    column_names = [:change_type, :ssn_an, :ssn_gn, :ssn_sn, :last_name, :name_suffix,
       :first_name, :middle_name, :verify_proof_code, :death_month, :death_day,
       :death_year, :birth_month, :birth_day, :birth_year, :state_of_residence,
       :last_known_zip_residence, :last_known_zip_payment, :extra, :as_of]
    while line = file.gets
      new_entry = parse_line_array(line, date)
      batch << new_entry if new_entry[1] > after
      if batch.size >= 1000
        import column_names, batch, validate: false,
          on_duplicate_key_update: 'id=id'  # ignore duplicates
        batch = []
      end
    end
    import column_names, batch, validate: false,
      on_duplicate_key_update: 'id=id'  # ignore duplicates
    ActiveRecord::Base.logger = old_logger
    file.close
  end
end
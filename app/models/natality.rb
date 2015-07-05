class Natality < ActiveRecord::Base
# from ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/natality/

  # LOAD DATA INFILE '/var/lib/mysql/Nat1968.dat' INTO TABLE natality (@x) SET
  # source_year= 1968,
  # shipment_number = substr(@x, 2,2),
  # reporting_area = substr(@x, 4,1),
  # record_type = substr(@x, 11,1),
  # resident = substr(@x, 12,1),
  # state = substr(@x,13,2),
  # county = substr(@x,15,3),
  # city=substr(@x,18,3),
  # population_size = substr(@x,21,1),
  # smsa = substr(@x,22,3),
  # metropolitan=substr(@x,25,1),
  # race_father = substr(@x,26,1),
  # race_mother=substr(@x,27,1),
  # race_child=substr(@x,28,1),
  # sex=substr(@x,31,1),
  # birth_month=substr(@x,32,2),
  # age_mother=substr(@x,38,2),
  # children_born_alive=substr(@x,47,2),
  # attendant_at_birth=substr(@x,58,1),
  # gestation_period=substr(@x,59,2),
  # weight_at_birth=substr(@x,62,4),
  # legitimacy=substr(@x,69,1),
  # number_at_birth=substr(@x,70,1),
  # place_of_occurrence=substr(@x,74,5);

end
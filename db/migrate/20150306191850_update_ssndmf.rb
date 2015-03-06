class UpdateSsndmf < ActiveRecord::Migration
  def change
    drop_table :death_master_files
    create_table :death_master_files do |t|
      t.string :change_type, limit: 1 # Add, Change, Delete
      t.integer :ssn, limit: 4 # 9 digits
      t.integer :ssn_an, limit: 2 # first 3, area number
      t.integer :ssn_gn, limit: 1 # next 2, group number
      t.integer :ssn_sn, limit: 2 # last 4, serial number
      t.string :last_name, limit: 20
      t.string :name_suffix, limit: 4
      t.string :first_name, limit: 15
      t.string :middle_name, limit: 15
      t.string :verify_proof_code, limit: 1 # Verified, Proof
      t.integer :death_month, limit: 1
      t.integer :death_day, limit: 1
      t.integer :death_year, limit: 2
      t.date :death_date
      t.integer :birth_month, limit: 1
      t.integer :birth_day, limit: 1
      t.integer :birth_year, limit: 2
      t.date :birth_date
      t.string :state_of_residence, limit: 2
      t.string :last_known_zip_residence, limit: 5
      t.string :last_known_zip_payment, limit: 5
      t.string :extra, limit: 7 # not documented
      t.date :as_of

      t.index [:ssn, :as_of], :unique => true
      t.index [:ssn_an, :ssn_gn, :ssn_sn]
      t.index [:birth_year, :birth_month, :birth_day, :ssn_an, :ssn_gn, :ssn_sn], name: 'idx_dob_ssn'
    end
  end
end

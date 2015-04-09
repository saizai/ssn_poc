class DropRedundantColumns < ActiveRecord::Migration
  def change
    with_tmp_table :death_master_files do |t|
      remove_column t, :ssn
      remove_column t, :birth_date
      remove_column t, :death_date

      remove_index t, name: :index_death_master_files_on_ssn_and_as_of
      remove_index t, name: :index_death_master_files_on_ssn_an_and_ssn_gn_and_ssn_sn
      remove_index t, name: :idx_dob_ssn
      remove_index t, name: :index_death_master_files_on_birth_date_and_lifespan
      remove_index t, name: :idx_dod_lifespan
      remove_index t, name: :index_death_master_files_on_ssn_an_and_lifespan
      remove_index t, name: :index_death_master_files_on_last_name_and_lifespan
      remove_index t, name: :index_death_master_files_on_first_name_and_lifespan
      change_column t, :lifespan, :integer, limit: 3, unsigned: true

      add_index t, [:ssn_an, :ssn_gn, :ssn_sn, :as_of], unique: true, name: :idx_ssn_as_of
      add_index t, [:birth_year, :birth_month, :ssn_an], name: :idx_dob_ssn
    end
  end
end

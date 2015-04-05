class AddIndexes < ActiveRecord::Migration
  def change

    with_tmp_table :death_master_files do |t|
      change_column t, :ssn, :integer, limit: 4, unsigned: true
      change_column t, :ssn_an, :integer, limit: 2, unsigned: true
      change_column t, :ssn_gn,  :integer, limit: 1, unsigned: true
      change_column t, :ssn_sn, :integer, limit: 2, unsigned: true
      change_column t, :death_month, :integer, limit: 1, unsigned: true
      change_column t, :death_day, :integer, limit: 1, unsigned: true
      change_column t, :death_year, :integer, limit: 2, unsigned: true
      change_column t, :birth_month, :integer, limit: 1, unsigned: true
      change_column t, :birth_day, :integer, limit: 1, unsigned: true
      change_column t, :birth_year, :integer, limit: 2, unsigned: true

      # in days
      add_column t, :lifespan, :integer, unsigned: true

      add_index t, [:last_name, :ssn_an, :birth_date], name: :idx_name_an_dob
      add_index t, [:last_name, :first_name], name: :idx_last_name_first_name
      add_index t, [:ssn_an, :lifespan]
      add_index t, [:birth_date, :lifespan]
      add_index t, [:death_year, :death_month, :lifespan], name: :idx_dod_lifespan
      add_index t, [:last_name, :lifespan]
      add_index t, [:first_name, :lifespan]
    end

    DeathMasterFile.find_each do |r|
      if r.birth_date
        dob = r.birth_date
      elsif r.birth_year && r.birth_month
        if r.death_day
          dob = Date.new(r.birth_year, r.birth_month, r.death_day)
        else
          dob = Date.new(r.birth_year, r.birth_month, 1)
        end
      else
        next
      end

      if r.death_date
        dod = r.death_date
      elsif r.death_year && r.death_month
        dod = Date.new(r.death_year, r.death_month, dob.day)
      else
        next
      end

      r.update_attribute :lifespan, (dod-dob).to_i
    end
  end
end

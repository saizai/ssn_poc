class AddIndexes < ActiveRecord::Migration
  def change
    change_table :death_master_files do |t|
      t.change :ssn, :integer, limit: 4, unsigned: true
      t.change :ssn_an, :integer, limit: 2, unsigned: true
      t.change :ssn_gn,  :integer, limit: 1, unsigned: true
      t.change :ssn_sn, :integer, limit: 2, unsigned: true
      t.change :death_month, :integer, limit: 1, unsigned: true
      t.change :death_day, :integer, limit: 1, unsigned: true
      t.change :death_year, :integer, limit: 1, unsigned: true
      t.change :birth_month, :integer, limit: 1, unsigned: true
      t.change :birth_day, :integer, limit: 1, unsigned: true
      t.change :birth_year, :integer, limit: 1, unsigned: true

      t.integer :lifespan, unsigned: true

      # t.index [:last_name, :ssn_an, :birth_date], name: :idx_name_an_dob
      t.index [:last_name, :first_name]
      t.index [:ssn_an, :lifespan]
      t.index [:birth_date, :lifespan]
      t.index [:death_year, :death_month, :lifespan], name: :idx_dod_lifespan
      t.index [:last_name, :lifespan]
      t.index [:first_name, :lifespan]
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

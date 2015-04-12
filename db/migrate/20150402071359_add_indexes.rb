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

      add_index t, [:last_name, :ssn_an, :birth_date], name: :idx_last_name_an_dob
      add_index t, [:last_name, :first_name], name: :idx_last_name_first_name
      add_index t, [:ssn_an, :lifespan]
      add_index t, [:birth_date, :lifespan]
      add_index t, [:death_year, :death_month, :lifespan], name: :idx_dod_lifespan
      add_index t, [:last_name, :lifespan]
      add_index t, [:first_name, :lifespan]
    end

    # Updating ~86M rows is not a job for ruby.
    # See http://dba.stackexchange.com/questions/97543/
    execute <<-SQL
      SET SESSION sql_mode = 'strict_all_tables';
      SET SESSION sql_warnings = 1;
      \W
      DELIMITER //
      DROP PROCEDURE IF EXISTS update_dmf_lifespan//
      CREATE PROCEDURE update_dmf_lifespan(INOUT i INT)
      BEGIN
       SET @i = i;
       SET @max = (select id from death_master_files order by id desc limit 1);
       setloop: LOOP
        UPDATE death_master_files SET lifespan = DATEDIFF(MAKEDATE(death_year, 1) + INTERVAL (death_month-1) MONTH + INTERVAL (IFNULL(IFNULL(death_day,birth_day),1)-1) DAY, MAKEDATE(birth_year, 1) + INTERVAL (birth_month-1) MONTH + INTERVAL (IFNULL(birth_day,1)-1) DAY) WHERE DATEDIFF(MAKEDATE(death_year, 1) + INTERVAL (death_month-1) MONTH + INTERVAL (IFNULL(IFNULL(death_day,birth_day),1)-1) DAY, MAKEDATE(birth_year, 1) + INTERVAL (birth_month-1) MONTH + INTERVAL (IFNULL(birth_day,1)-1) DAY) >= 0 and id BETWEEN @i AND @i+10000;
        SELECT @i, ROW_COUNT(), LAST_INSERT_ID();
        SELECT *, DATEDIFF(MAKEDATE(death_year, 1) + INTERVAL (death_month-1) MONTH + INTERVAL (IFNULL(IFNULL(death_day,birth_day),1)-1) DAY, MAKEDATE(birth_year, 1) + INTERVAL (birth_month-1) MONTH + INTERVAL (IFNULL(birth_day,1)-1) DAY) as diff from death_master_files WHERE DATEDIFF(MAKEDATE(death_year, 1) + INTERVAL (death_month-1) MONTH + INTERVAL (IFNULL(IFNULL(death_day,birth_day),1)-1) DAY, MAKEDATE(birth_year, 1) + INTERVAL (birth_month-1) MONTH + INTERVAL (IFNULL(birth_day,1)-1) DAY) < 0 and id BETWEEN @i AND @i+10000;
        SET @i = @i + 10000;
        IF @i + 10000 > @max THEN
         LEAVE setloop;
        END IF;
       END LOOP setloop;
      END
      //
      SET @i = 1//
      CALL update_dmf_lifespan(@i)//
      DROP PROCEDURE IF EXISTS update_dmf_lifespan//
      DELIMITER ;
    SQL

  end
end

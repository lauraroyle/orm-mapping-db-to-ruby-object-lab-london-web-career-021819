class Student

  attr_accessor :id, :name, :grade

#CREATE NEW STUDENT FROM ROW IN DB
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end


#RETURN ALL STUDENTS IN DB
  def self.all
    sql = <<-SQL #sql variable is set equal to sql commands to retrieve all data from the database
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row| #DB is given sql as an argument and the execute will will return an array of rows from the database that match our query.
      self.new_from_db(row) #Now, all we have to do is iterate over each row and use the self.new_from_db method to create a new Ruby object for each row.
    end
  end


#FIND STUDENT IN DB GIVEN NAME
#RETURN NEW INSTANCE OF STUDENT
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name =?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first #The return value of the .map method is an array, and we're simply grabbing the .first element from the returned array.
  end


#HELPER METHOD SAVE TO DB
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

#CREATE TABLE IN DB
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

#DROPS TABLE FOR STUDENTS
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

#RETURN an array of all the students in grade 9.
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade=9
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
  end
end


  #RETURN an array of all the students below 12th grade.
    def self.students_below_12th_grade
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade<12
      SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
    end
end

    #RETURN an array of exactly `X` number of students
      def self.first_X_students_in_grade_10(number)
        sql = <<-SQL
          SELECT *
          FROM students
          WHERE grade= 10
        SQL
        array = DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
        end
        array.slice(0, number)
    end

    #RETURN the first student in grade 10
      def self.first_student_in_grade_10
        sql = <<-SQL
          SELECT *
          FROM students
          WHERE grade= 10
        SQL
        DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
      end.first
    end

    #RETURN all students in grade X
    def self.all_students_in_grade_X(grade)
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade =?
      SQL

      DB[:conn].execute(sql, grade).map do |row|
        self.new_from_db(row)
      end
    end


end

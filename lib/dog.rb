class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, :breed:, :id=nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
   sql = "DROP TABLE IF EXISTS dogs"

   DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
   dog = self.new(name: row[1], breed: row[2], id: row[0])
   dog
  end
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
    SQL

    result = DB[:conn].execute(sql, name)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
   end

   def update
    sql = <<-SQL
      UPDATE dogs
      SET name = ?, breed = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end
end

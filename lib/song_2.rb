class Song
  # from mapping database tables to ruby objects

  #convention is to pluralize the name of the class to create the name of the table
  #song class equals songs table
  # access the DB with DB[:conn]

  # The important concept to grasp here is the idea that we are not saving Ruby objects into our database.
  # We are using the attributes of a given Ruby object to create a new row in our database table.



  attr_accessor :name, :length
  attr_reader :id

  def initialize(name, album, id=nil)
     @id = id
     @name = name
     @album = album
  end

  def self.create(name:, album:)
    song = Song.new(name, album)
    song.save
    song
  end

  def self.create_table
    sql =  <<-SQL
       CREATE TABLE IF NOT EXISTS songs (
         id INTEGER PRIMARY KEY,
         name TEXT,
         album TEXT
         )
         SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
       VALUES (?, ?)
       SQL

    DB[:conn].execute(sql, self.name, self.album)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

  end

  def self.new_from_db(row)
    new_song = self.new #self.new is the same as running Song.new
    new_song.id = row[0]
    new_song.name = row[1]
    new_song.length = row[2]
    new_song
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM songs
      SQL
    # DB[:conn].execute(sql) will return an array of rows, so create an object for each row
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM songs
      WHERE name = ?
      LIMIT 1
      SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first

  end


end

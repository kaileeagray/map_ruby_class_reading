class Song
  #convention is to pluralize the name of the class to create the name of the table
  #song class equals songs table
  # access the DB with DB[:conn]

  # The important concept to grasp here is the idea that we are not saving Ruby objects into our database.
  # We are using the attributes of a given Ruby object to create a new row in our database table.



  attr_accessor :name, :album, :id

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

end

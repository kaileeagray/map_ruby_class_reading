class Song
  #convention is to pluralize the name of the class to create the name of the table
  #song class equals songs table

  attr_accessor :name, :album

  def initialize(name, album)
    @name = name
    @album = album
  end

end

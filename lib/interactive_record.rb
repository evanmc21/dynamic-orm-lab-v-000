require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "pragma table_info('#{table_name}')" #access the name of the tabe we're querying

    table_info = DB[:conn].execute(sql)
    column_names = [] #set to empty array
    table_info.each do |row| #iterate to collect only the name of the each column
    column_names << row["name"] #shovel collection of column names we just collected into column_names array
  end
    column_names.compact
  end

  self.column_names.each do |col_name| #iterating over the colummn names and set an attr_accessor for each one and convert the column name string into a symbol.
    attr_accessor col_name.to_sym
  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value) #metaprogram to interpolate the name of each hash key as a method that we set equal to that key's value.
    end
  end

  def save
  sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
  DB[:conn].execute(sql)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def table_name_for_insert
    self.class.table_name
  end


end

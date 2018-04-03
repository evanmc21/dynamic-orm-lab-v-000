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

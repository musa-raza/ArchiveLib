require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

class SQLObject
  def self.columns
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
     #{self.table_name}
    SQL
    @columns = columns.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end
       define_method("#{column}=") do |value|
         self.attributes[column] = value
    end
 end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    SQL
    parse_all(data)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result)}
  end

  def self.find(id)
    data = DBConnection.execute(<<-SQL, id)
    SELECT
    #{table_name}.*
    FROM
    #{table_name}
    WHERE
    #{table_name}.id = ?
    SQL
    return nil if data.empty?
    parse_all(data).first
  end

  def initialize(params = {})
    # ...
    params.each do |k, v|
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k.to_sym)
      self.send("#{k}=", v)
    end
  end


  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |data| self.send(data) }
  end

  def insert
    result_array = []
    col_names = self.class.columns
    col_names.length.times { result_array << "?"}
    col_names = col_names.join(", ")
    question_marks = result_array.join(", ")
    data = DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
    #{self.class.table_name} (#{col_names})
    VALUES
    (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
   set_line = self.class.columns.map { |attr_name| "#{attr_name} = ?" }.join(", ")
   DBConnection.execute(<<-SQL, *attribute_values, id)
   UPDATE
   #{self.class.table_name}
   SET
   #{set_line}
   WHERE
   #{self.class.table_name}.id = ?
   SQL

  end

  def save
    self.id.nil? ? insert : update
  end
end

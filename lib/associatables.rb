require_relative 'searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.to_s.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :primary_key => :id,
      :foreign_key => ("#{name}_id").to_sym,
      :class_name => name.to_s.capitalize.singularize
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :primary_key => :id,
      :foreign_key => ("#{self_class_name.downcase}_id").to_sym,
      :class_name => name.to_s.capitalize.singularize
    }

    defaults.keys.each do |key|
      self.send("#{key}=", options[key] || defaults[key])
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      f_key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => f_key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      p_key = self.send(options.primary_key)
      options.model_class.where(options.foreign_key => p_key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

module Associatable

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      through_table = through_options.table_name
      source_table = source_options.table_name
      through_foreign_key = source_options.foreign_key
      through_primary_key = through_options.primary_key
      source_primary_key = source_options.primary_key
      source_foreign_key = source_options.foreign_key
      data = DBConnection.execute(<<-SQL, id)
      SELECT
      #{source_table}.*
      FROM
      #{through_table}
      JOIN
        #{source_table} ON #{through_table}.#{source_foreign_key} = #{source_table}.#{through_primary_key}
      WHERE
        #{through_table}.#{through_primary_key} = ?
      SQL
      return nil if data.empty?
      source_options.model_class.parse_all(data).first
    end
  end
end


class SQLObject
  extend Associatable
end

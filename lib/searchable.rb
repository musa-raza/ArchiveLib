require_relative 'db_connection'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    data =  ArchiveLib::DBConnection.execute(<<-SQL, *params.values)
     SELECT
      *
     FROM
     #{table_name}
     WHERE
     #{where_line}
     SQL
     parse_all(data)
  end
end

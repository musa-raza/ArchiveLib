require_relative '../lib/base'
require_relative '../lib/db_connection'

COMPUTERS_SQL_FILE = 'computers.sql'
COMPUTERS_DB_FILE =  'computers.db'

# `rm '#{COMPUTERS_DB_FILE}'`
`cat '#{COMPUTERS_SQL_FILE}' | sqlite3 '#{COMPUTERS_DB_FILE}'`

ArchiveLib::DBConnection.open(COMPUTERS_DB_FILE)

class Company < ArchiveLib::Base

  has_many :employees

end

class Employee < ArchiveLib::Base

  belongs_to :company

end


class Computer < ArchiveLib::Base

  belongs_to :employee,
  primary_key: :id,
  foreign_key: :owner_id,
  class_name: :Employee

  has_one_through :company,
  through: :employee,
  source: :company

end

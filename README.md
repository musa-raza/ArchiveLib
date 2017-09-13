# ArchiveLib

ArchiveLib is an Object-Relational Mapping (ORM) library for Ruby inspired by ActiveRecord.

## Try it
1. Download/Clone this repo and naviagate to the ./ArchiveLib/demo directory.
2. Open `pry`/`irb` and run `load 'demo.rb'` in the terminal.
  1. This will create the tables `companies`, `employees`, & `computers`.
3. Try intuitive `belongs_to` or `has_many` associations amongst the models. Try `Company.first.employees` or `Computer.first.company`.

## Using ArchiveLib

With this app, you can create `belongs_to`, `has_many` or `has_one_through` associations between tables.

## Methods for interaction with database.

Here is a list of methods available for interacting with the database.

 ### Base
* `::all` : Returns array of all entries for given table.

  Example: `Employee.all`

* `::first`: Returns first entry from a table.

  Example: `Employee.first`

* `::last` : Returns last entry from the table.

  Example: `Employee.last`

* `::find(id)` : Returns an entry for a given id from a table.

  Example: `Employee.find(1)`

* `::new` : Creates a new entry for a table.

* `#save` : Creates or updates an entry for a table.

    Example:
    ```
    employee = Employee.new
    employee.fname = "John"
    employee.lname = "Doe"
    employee.company_id = 2
    employee.save
    ```

* `#update` : Updates an existing entry for a table.

  Example: `Employee.update(1, fname: "Musa", lname: "Raza", company_id: 3)`

* `#insert` : Inserts a new entry into the table.

### Searchable
* `::where` : Returns an array of all the items that match the where clause in the query.

  Example: `Employee.where(name: "Anthony")`

### Associatable
* `::has_many`: Returns an array of all the child associations.

  Example: `Company.first.employees`

* `::belongs_to`: Returns an entry which has the parent association.

  Example: `Employee.last.company`

* `::has_one_through`: Specifies a one to one relationship between two models, traversing through an intermediary model.

  Example: `Computer.first.company`

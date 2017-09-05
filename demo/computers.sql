CREATE TABLE computers (
  id INTEGER PRIMARY KEY,
  model VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES employees(id)
);

CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  company_id INTEGER,

  FOREIGN KEY(company_id) REFERENCES companies(id)
);

CREATE TABLE companies (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  companies (id, name)
VALUES
  (1, "Google"), (2, "Amazon"), (3, "Facebook"), (4, "Instagram");

INSERT INTO
  employees (id, fname, lname, company_id)
VALUES
  (1, "Musa", "Raza", 1),
  (2, "Calvin", "Jee", 1),
  (3, "Julian", "Jurai", 2),
  (4, "Anthony", "Rondinone", 2),
  (5, "Brendan", "Ko", 3),
  (6, "Kenneth", "Ng", 3),
  (7, "Albert", "Ngo", 4),
  (8, "Nate", "Chapman", 4);

INSERT INTO
  computers (id, model, owner_id)
VALUES
  (1, "Macbook Pro", 1),
  (2, "Surface", 2),
  (3, "Inspiron", 3),
  (4, "Vaio", 4),
  (5, "Macbook Air", 5),
  (6, "Gateway", 6),
  (7, "Toshiba", 7),
  (8, "Lenovo", 8);

# Inch Technical Test

This is Ruby on Rails app that will update the database to match the data the clients provide in CSV format on a daily basis.

The objective is to code the CSV import and handle some specific update rules.

## Structure

### Models
- The app has 2 main models as requested in the test (Building and Person).
I have added 2 models to store history data for buildings manager_name (`BuildingHistory`) and for people email, home_phone_number, mobile_phone_number and address (`PersonHistory`).
- A building has many building_histories. A building_history belongs_to a building.
- A person has many person_histories. A person_history belongs_to a person.

### Controllers
The app has 2 controllers, one for each main model, to :
- show index of records
- perform the csv import by calling the `ImportCsv` service (see next section)

### Services
The requested feature can be found in `app/services/import_csv.rb`.
This service can process import for buildings data as well as for people data.
To create a new import, provide a file path and a Model (`Person` or `Building`), and call the `ImportCsv` class `perform` method.
```
ImportCsv.new(file_path, Model).perform
```

Regarding test step 2:
- For `Building` model, the `manager_name` attribute will be overwritten by the csv import only if the value provided in the csv has never been a value of that field.
- But for `Person` model, the `email`, `home_phone_number`, `mobile_phone_number` and `address` will all be overwritten by the csv import, only if all of them have never been a value of the fields.

### Tests
I have written tests only for the service to check expected results given the input files.


## Versions :

Ruby - 2.5.1

Rails - 5.2.4

DB - PostgreSQL

Framework - Ruby on Rails

## To start :
To use this app locally, download the repo or clone it.

### Installation:
```bash
bundle install
```
```bash
rails db:create
```
```bash
rails db:migrate
```
```bash
rails server
```
Then go to ```http://localhost:3000/```

## How to test the app ?

### Via Rspec
Run ```rspec``` 

### By using input files
Some csv files are provided in spec/fixtures folder
# Service to process CSV Import
class ImportCsv
  require 'csv'

  attr_reader :file, :model

  # Initialize object with given file and model
  # If model is neither Person nor Building, @model stays nil
  def initialize(file, model)
    begin
      @file = file
      if model == Person || model == Building
        @model = model
      else
        raise NameError.new
      end
    rescue NameError => e
      puts 'Choose between Person or Building models only'
    end
  end

  # For each row of the file, read CSV
  # Transform attributes to hash
  # Find the record or create a new one
  # Update the attributes if the value was already given
  # Then store everything  
  def perform
    unless @model.nil?
      ActiveRecord::Base.transaction do
        CSV.foreach(file.path, headers: true) do |row|
          attributes = row.to_hash
          record = @model.find_or_initialize_by(reference: attributes['reference'])
          attributes = transform_attributes(attributes, record)
          record.update(attributes) 
        end
      end
    end
  end

  # Private methods
  private

  # Returns transformed attributes if record already exists
  # And has a history record with same values
  def transform_attributes(attributes, record)
    history = history(record)
                .find_or_initialize_by(history_attributes(attributes))
    attributes = restore_attributes(attributes, record) if restore_attributes?(history, record)
    history.update(history_attributes(attributes))
    attributes
  end

  # Get the record history depending on the model
  def history(record)
    @model == Building ? record.building_histories : record.person_histories
  end

  # Returns a boolean if the record has a previous history
  def restore_attributes?(history, record)
    !history.new_record? && !record.new_record?
  end

  # Returns restored attributes
  def restore_attributes(attributes, record)
    if @model == Building
      attributes['manager_name'] = record.manager_name
    elsif @model == Person
      attributes['email'] = record.email
      attributes['home_phone_number'] = record.home_phone_number
      attributes['mobile_phone_number'] = record.mobile_phone_number
      attributes['address'] = record.address
    end
    attributes
  end

  # Get history attributes depending on the model
  def history_attributes(attributes)
    if @model == Building
      history_attributes = { manager_name: attributes['manager_name'] }
    elsif @model == Person
      history_attributes = {
                            email: attributes['email'],
                            home_phone_number: attributes['home_phone_number'],
                            mobile_phone_number: attributes['mobile_phone_number'],
                            address: attributes['address']
                        }
    end
  end

end
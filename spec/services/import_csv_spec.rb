require 'rails_helper'

RSpec.describe ImportCsv do

  # Arrange /  # Act  /   # Assert

  # Import first buildings and first people
  ImportCsv.new(File.open('spec/fixtures/buildings.csv'), Building).perform
  ImportCsv.new(File.open('spec/fixtures/people.csv'), Person).perform

  subject { ImportCsv.new(file, model).perform }

  context 'Model Issues' do
    let(:file) { File.open('spec/fixtures/buildings.csv') }

    describe 'existing model different than Building or Person' do
      let(:model) { BuildingHistory }

      it 'should not raise an error' do
        expect{subject}.not_to raise_error
      end

      it 'should not not change count of models' do
        expect{subject}.not_to change(Building, :count)
        expect{subject}.not_to change(BuildingHistory, :count)
        expect{subject}.not_to change(Person, :count)
        expect{subject}.not_to change(PersonHistory, :count)
      end
    end

    describe 'Building data with People model' do 
      let(:model) { Person }
      it 'should not raise an error' do
        expect{subject}.not_to raise_error
      end
      it 'should return error message' do
        expect(subject).to eq("unknown attribute 'zip_code' for Person.")
      end
    end

    describe 'People data with Building model' do 
      let(:file) { File.open('spec/fixtures/people.csv') }
      let(:model) { Building }
      it 'should not raise an error' do
        expect{subject}.not_to raise_error
      end
      it 'should return error message' do
        expect(subject).to eq("unknown attribute 'firstname' for Building.")
      end
    end

    describe 'non existing model' do
      let(:model) { People }
      it 'should raise an error' do
        expect{subject}.to raise_error(NameError)
      end
    end

  end

  context 'Buildings' do
    let(:model) { Building }
    let(:test_building) { Building.find_by(reference: '1') }

    describe 'new buildings' do
      let(:file) { File.open('spec/fixtures/buildings2.csv') }
      it 'should increase Building.count by 2' do
        expect{subject}.to change(Building, :count).by(2)
      end
    end

    describe 'existing buildings without history' do
      let(:file) { File.open('spec/fixtures/buildings_update1.csv') } 
      it 'should update and not change Building.count' do
        expect{subject}.not_to change(Building, :count)
        expect(test_building.manager_name).to eq('Sofia Chakir')
        expect(test_building.address).to eq('15 rue des Favorites')
      end
    end

    describe 'existing buildings with history' do
      let(:file0) { File.open('spec/fixtures/buildings_update1.csv') }
      let(:file) { File.open('spec/fixtures/buildings_update2.csv') } 
      it 'should not update manager_name only' do
        ImportCsv.new(file0, model).perform
        expect{subject}.not_to change(Building, :count)
        expect(test_building.manager_name).to eq('Sofia Chakir')
        expect(test_building.address).to eq('10 Rue La bruyère')
      end   
    end
  end

  context 'People' do
    let(:file) { File.open('spec/fixtures/people.csv') }
    let(:model) { Person }
    let(:test_person) { Person.find_by(reference: '1') }

    describe 'new people' do
      let(:file) { File.open('spec/fixtures/people2.csv') }
      it 'should increase Person.count by 1' do
        expect{subject}.to change(Person, :count).by(1)
      end
    end

    describe 'existing people without history' do
      let(:file) { File.open('spec/fixtures/people_update1.csv') }
      it 'should update and not change Person.count' do
        expect{subject}.not_to change(Person, :count)
        expect(test_person.email).to eq('sofia@yopmail.com')
        expect(test_person.address).to eq('11 Rue La bruyère')
      end
    end

    describe 'existing people with history' do
      let(:file0) { File.open('spec/fixtures/people_update1.csv') }
      let(:file) { File.open('spec/fixtures/people_update2.csv') }
      it 'should not update email, address, home_phone_number and mobile_phone_number only' do
        ImportCsv.new(file0, model).perform
        expect{subject}.not_to change(Person, :count)
        expect(test_person.email).to eq('sofia@yopmail.com')
        expect(test_person.firstname).to eq('Henri')
      end
    end

  end

  


end
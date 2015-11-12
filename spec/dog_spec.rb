require_relative 'spec_helper'

describe Dog do

  context "attributes" do
    describe "instance" do
      it " has an id, name, color, breed and instagram handle" do

        attributes = {
          :id => 1,
          :name => "Teddy",
          :breed => "Cockapoo",
          :color => "Black",
          :instagram => "theodore_michael"
        }

        teddy = Dog.new
        teddy.id = attributes[:id]
        teddy.name = attributes[:name]
        teddy.breed = attributes[:breed]
        teddy.color = attributes[:color]
        teddy.instagram = attributes[:instagram]

        expect(teddy.id).to eq(attributes[:id])
        expect(teddy.name).to eq(attributes[:name])
        expect(teddy.breed).to eq(attributes[:breed])
        expect(teddy.color).to eq(attributes[:color])
        expect(teddy.instagram).to eq(attributes[:instagram])

      end
    end
  end

  describe '::create_table' do
    it 'creates a dog table' do
      DB[:conn].execute('DROP TABLE IF EXISTS dogs')
      dog.create_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['dogs'])
    end
  end

  describe '::drop_table' do
    it "drops the dog table" do
      dog.drop_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='dogs';"
      expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
    end
  end

  describe '#insert' do
    it 'inserts the dog into the database' do
      teddy = Dog.new
      teddy.id = attributes[:id]
      teddy.name = attributes[:name]
      teddy.breed = attributes[:breed]
      teddy.color = attributes[:color]
      teddy.instagram = attributes[:instagram]

      teddy.insert

      select_sql = "SELECT name FROM dogs WHERE name = 'Teddy'"
      result = DB[:conn].execute(select_sql)[0]

      expect(result[0]).to eq("Teddy")
    end

    it 'updates the current instance with the ID of the dog from the database' do
      teddy = Dog.new
      teddy.id = attributes[:id]
      teddy.name = attributes[:name]
      teddy.breed = attributes[:breed]
      teddy.color = attributes[:color]
      teddy.instagram = attributes[:instagram]

      teddy.insert

      expect(teddy.id).to eq(1)
    end
  end

  describe '::new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Teddy", "cockapoo", "black", "theodore_michael"]
      teddy = Dog.new_from_db(row)

      expect(teddy.id).to eq(row[0])
      expect(teddy.name).to eq(row[1])
      expect(teddy.breed).to eq(row[2])
      expect(teddy.color).to eq(row[3])
      expect(teddy.instagram).to eq(row[4])
    end
  end

  describe '::find_by_name' do
    it 'returns an instance of student that matches the name from the DB' do
      teddy = Dog.new
      teddy.id = attributes[:id]
      teddy.name = attributes[:name]
      teddy.breed = attributes[:breed]
      teddy.color = attributes[:color]
      teddy.instagram = attributes[:instagram]

      teddy.insert

      teddy_from_db = Dog.find_by_name("Teddy")
      expect(teddy_from_db.name).to eq("Teddy")
      expect(teddy_from_db).to be_an_instance_of(Dog)
    end
  end

  describe "#update" do
    it 'updates and persists a dog in the database' do
      teddy = Dog.new
      teddy.name = "Teddy"
      teddy.insert

      teddy.name = "Bob"
      original_id = teddy.id

      teddy.update

      teddy_from_db = Dog.find_by_name("Teddy")
      expect(teddy_from_db).to be_nil

      bob_from_db = Dog.find_by_name("Teddy")
      expect(bob_from_db).to be_an_instance_of(Dog)
      expect(bob_from_db.name).to eq("Bob")
      expect(bob_from_db.id).to eq(original_id)
    end
  end

  describe '#save' do
    it "chooses the right thing on first save" do
      teddy = Dog.new
      tedd.name = "Teddy"
      expect(teddy).to receive(:insert)
      teddy.save
    end

    it 'chooses the right thing for all others' do
      tedd = Dog.new
      teddy.name = "Teddy"
      teddy.save

      teddy.name = "Bob"
      expect(teddy).to receive(:update)
      teddy.save
    end
  end
end

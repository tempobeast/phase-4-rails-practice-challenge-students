class Student < ApplicationRecord
    belongs_to :instructor, required: true

    validates :name, presence: true
    validates :age, :numericality => { :only_integer => true, :greater_than_or_equal_to => 18 }
    validates :instructor_id, presence: true
end

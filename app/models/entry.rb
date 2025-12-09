class Entry < ApplicationRecord
  belongs_to :exercise, optional: true 
  before_save :normalise_exercise_name

# validation
  validates :performed_on, presence: true
  validates :exercise_name, presence: true
  validates :sets, presence: true
  validates :reps, presence: true
  validates :weight, presence: true


  private

  def normalise_exercise_name
    self.exercise_name = exercise_name.strip.titleize if exercise_name.present?
  end
end

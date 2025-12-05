class ProgressController < ApplicationController
  def index
    # What exercise has been selected from the dropdown?
    @exercise  = params[:exercise]

    # List of unique exercise names for the dropdown
    @exercises = Entry.distinct.order(:exercise_name).pluck(:exercise_name)

    # Base scope
    scope = Entry.all

    if @exercise.present?
      scope = scope.where(exercise_name: @exercise)

      # For a specific exercise: show max weight per day
      @chart_title       = "Max weight per day for #{@exercise}"
      @series_by_day     = scope.group_by_day(:performed_on).maximum(:weight)
      @y_axis_label      = "Weight (kg)"
    else
      # No exercise chosen: show total volume for all exercises
      @chart_title   = "Total training volume per day"
      @series_by_day = scope.group_by_day(:performed_on).sum("sets * reps * weight")
      @y_axis_label  = "Volume (sets × reps × weight)"
    end
  end
end


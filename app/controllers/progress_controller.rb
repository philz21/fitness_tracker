class ProgressController < ApplicationController
  def index
    @exercise = params[:exercise]

    # Dropdown options – unique, nicely formatted
    @exercises =
      Entry
        .select("DISTINCT LOWER(exercise_name) AS name")
        .order("name")
        .map { |e| e.name.titleize }

    scope = Entry.all

    if @exercise.present?
      # Filter to that exercise
      scope = scope.where("LOWER(exercise_name) = ?", @exercise.downcase)

      # One point per day: max weight on that day
      @series_by_day = scope.group(:performed_on).maximum(:weight)

      @chart_title  = "Max weight per day for #{@exercise}"
      @y_axis_label = "Weight (kg)"
    else
      # All exercises → total volume per day
      @series_by_day = scope.group(:performed_on).sum("sets * reps * weight")

      @chart_title  = "Total training volume per day"
      @y_axis_label = "Volume"
    end
  end
end






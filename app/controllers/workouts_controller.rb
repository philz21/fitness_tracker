class WorkoutsController < ApplicationController
  def index
    # show all workouts + an empty one for the form
    @workouts = Workout.order(performed_on: :desc)
    @workout  = Workout.new
  end

  def create
    @workout = Workout.new(workout_params)
    if @workout.save
      redirect_to root_path, notice: "Workout added!"
    else
      @workouts = Workout.order(performed_on: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @workout = Workout.find(params[:id])
  end

  def update
    @workout = Workout.find(params[:id])
    if @workout.update(workout_params)
      redirect_to root_path, notice: "Workout updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Workout.find(params[:id]).destroy
    redirect_to root_path, notice: "Workout deleted."
  end

  private

  def workout_params
    params.require(:workout).permit(:exercise_name, :sets, :reps, :weight, :performed_on)
  end
end


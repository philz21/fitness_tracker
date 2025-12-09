class EntriesController < ApplicationController
    #before_action :authenticate_user!
  def index
    @entry = Entry.new

    if params[:exercise].present?
      @entry.exercise_name = params[:exercise]
    end

    @query = params[:query]
    @sort  = params[:sort]

    # Start with all entries
    @entries = Entry.all

    # Apply search filter (if any)
    if @query.present?
      @entries = @entries.where("exercise_name ILIKE ?", "%#{@query}%")

    end

    # Apply sorting
    @entries =
      case @sort
      when "oldest"
        @entries.order(performed_on: :asc)
      when "heaviest"
        @entries.order(weight: :desc)
      when "most_reps"
        @entries.order(reps: :desc)
      when "highest_volume"
        # sets * reps * weight, biggest first
        @entries.order(Arel.sql("sets * reps * weight DESC"))
      else
        # default: newest first
        @entries.order(performed_on: :desc)
      end
     @entries = @entries.page(params[:page]).per(10)
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      redirect_to root_path, notice: "Workout entry added!"
    else
      @entries = Entry.order(performed_on: :desc).page(params[:page]).per(10)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update(entry_params)
      redirect_to root_path, notice: "Workout entry updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    redirect_to root_path, notice: "Workout entry deleted."
  end

  private

  def entry_params
    params.require(:entry).permit(:exercise_name, :sets, :reps, :weight, :performed_on, :exercise_id)
  end
end

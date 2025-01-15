class JobsController < ApplicationController
  include Filterable

  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /jobs or /jobs.json
  def index
    @jobs = filter!(Job).for_account(current_user.account_id)
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)
    @job.account = current_user.account

    if @job.save
      render turbo_stream: turbo_stream.prepend(
        "jobs",
        partial: "job",
        locals: { job: @job }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "job-form",
        partial: "form",
        locals: { job: @job }
      ), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy!
    render turbo_stream: turbo_stream.remove(@job)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :status, :job_type, :location, :account_id, :description)
    end
end

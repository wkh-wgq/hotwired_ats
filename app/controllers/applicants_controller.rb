class ApplicantsController < ApplicationController
  before_action :set_applicant, only: %i[ show edit update destroy change_stage ]
  before_action :authenticate_user!

  # GET /applicants or /applicants.json
  def index
    @applicants = Applicant.all
  end

  # GET /applicants/1 or /applicants/1.json
  def show
  end

  # GET /applicants/new
  def new
    @applicant = Applicant.new
  end

  # GET /applicants/1/edit
  def edit
  end

  # POST /applicants or /applicants.json
  def create
    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      render turbo_stream: turbo_stream.prepend(
        "applicants-#{@applicant.stage}",
        partial: "card",
        locals: { applicant: @applicant }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "applicant-form",
        partial: "form",
        locals: { applicant: @applicant }
      ), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applicants/1 or /applicants/1.json
  def update
    respond_to do |format|
      if @applicant.update(applicant_params)
        format.html { redirect_to @applicant, notice: "Applicant was successfully updated." }
        format.json { render :show, status: :ok, location: @applicant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1 or /applicants/1.json
  def destroy
    @applicant.destroy!

    respond_to do |format|
      format.html { redirect_to applicants_path, status: :see_other, notice: "Applicant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def change_stage
    @applicant.update(applicant_params)
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_applicant
      @applicant = Applicant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def applicant_params
      params.require(:applicant).permit(:first_name, :last_name, :email, :phone, :stage, :status, :job_id, :resume)
    end
end

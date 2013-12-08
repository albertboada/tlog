class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy, :stop]

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs/:project_id
  def create
    project = Project.find(params[:id])

    log = Log.new
    log.project = project
    log.start   = Time.now

    respond_to do |format|
      if log.save
        notice = 'Log was successfully created.'
      else
        notice = 'Log was not successfully created.'
      end
      format.html { redirect_to project, notice: notice }
    end
  end

  def stop
    @log.finish = Time.now

    respond_to do |format|
      if @log.save
        notice = 'Log was successfully stopped.'
      else
        notice = 'Log was not successfully stopped.'
      end
      format.html { redirect_to @log.project, notice: notice }
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log.project, notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to @log.project }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:start, :finish, :comment)
    end
end

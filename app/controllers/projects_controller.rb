class ProjectsController < ApplicationController
  before_action :find_project, except: [:new]

  def new
    @project = Project.new
  end


  def index
    # comment!
    @q = Project.search(params[:q])
    @projects = @q.result(distinct: true).includes(:user)
  end

  def show
    if @project != nil
      @owner = User.find_by_id @project.owner
      # FIXME -- refactor
      if !@project.is_public
        if not (current_user && @owner == current_user)
          access_denied
        end
      else
        render action: "show"
      end
    end
  end

  def edit
    if @project != nil
      @owner = User.find_by_id @project.owner
      if not (current_user && @owner == current_user)
        access_denied
      end
      render action: "edit"
    else
      item_not_found
    end
  end

  def update
    if @project != nil
      @owner = User.find_by_id @project.owner
    end

    if @project.update_attributes(project_params)
      flash[:success] = "Project updated!"
      redirect_to @project
    else
      render action: "edit"
    end
  end

  def destroy
    proj = Project.find(params[:id])
    proj.destroy
  end

  private

    def find_project
      @project = nil
      if params[:username] && params[:projectname]
        find_project_by_name(params[:username], params[:projectname])
      elsif params[:id]
        # AR will automatically throw a not found exception
        @project = Project.find(params[:id])
      end
    end

    def project_params
      # FIXME -- verify with API controller?
      params.require(:project).permit(:title, :notes, :is_public, :contents, :snap_file)
    end

    def find_project_by_name(username, projectname)
      # TODO: Handle multiple ownership
      @owner = User.find_by!(username: username)
      @project = Project.find_by!(owner: @owner.id, title: projectname)
      if !@project.is_public && @project.owner != self.current_user.id
        access_denied
      end
    end
end

class SubmissionsController < ApplicationController
  before_filter :userLoggedIn
  before_filter :assignmentExists
  before_filter :canSubmit

    def create
      @assignment.submit(submission_params)
    end

    def submission_params
      params.require(:submission).permit(:project_id, :comments)
    end

    def userLoggedIn
      if getCurrentUser.nil?
        redirect_to login_path and return
      else
        @user = getCurrentUser
      end
    end

    def assignmentExists
      if !Assignment.exists?(params[:assignment_id])
        render file: "#{Rails.root}/public/404.html", layout: false, status: 404 and return
      else
        @assignment = Assignment.find(params[:assignment_id])
      end
    end

    def canSubmit
      course = @assignment.course
      if not course.student_ids.include? @user.id
        render file: "#{Rails.root}/public/401.html", layout: false, status: 401 and return
      end
    end


end
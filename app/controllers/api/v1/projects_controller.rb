module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!

      def index
        @projects = current_user.projects
        render json: @projects
      end

      def show
        @project = Project.include_all_tasks.find(params[:id])

        if @project.user == current_user
          render json: @project, include: {
            project_tasks: {
              only: %i[id title description priority due_date status]
            },
            sections: {
              include: {
                tasks: {
                  only: %i[id title description priority due_date status]
                }
              },
              only: %i[id title]
            }
          }
        else
          access_denied
        end
      end

      def create
        @project = current_user.projects.create(project_params)
        render_resource(@project)
      end

      def update
        @project = Project.find(params[:id])

        if @project.user == current_user
          @project.update(project_params)
          render_resource(@project)
        else
          access_denied
        end
      end

      def destroy
        @project = Project.find(params[:id])

        if @project.user == current_user
          @project.destroy
          render_resource(@project)
        else
          access_denied
        end
      end

      private

      def project_params
        params.require(:project).permit(:title)
      end
    end
  end
end

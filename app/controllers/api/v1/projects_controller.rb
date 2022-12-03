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
              only: %i[id title description priority due_date status project_id section_id]
            },
            sections: {
              include: {
                tasks: {
                  only: %i[id title description priority due_date status project_id section_id]
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

        # Make sure that the project belongs to the user and is NOT the inbox
        # Inbox is default project automatically created for the user and cannot be changed
        if @project.user == current_user && !@project.inbox
          @project.update(project_params)
          render_resource(@project)
        else
          access_denied
        end
      end

      def destroy
        @project = Project.find(params[:id])

        # Make sure that the project belongs to the user and is NOT the inbox
        # Inbox is default project automatically created for the user and cannot be changed
        if @project.user == current_user && !@project.inbox
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

module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task_parent, only: %i[create]

      def index
        @tasks = if params[:upcoming]
                   current_user.tasks.group_by(&:due_date)
                 elsif params[:today]
                   @tasks = current_user.tasks.where('due_date = ?', Date.today)
                 else
                   @tasks = current_user.tasks
                 end

        render json: { tasks: @tasks }
      end

      def create
        if @taskable.user == current_user
          @task = Task.create(
            task_params.merge(
              {
                project_id: @project_id,
                section_id: @section_id
              }
            )
          )
          render_resource(@task)
        else
          access_denied
        end
      end

      def update
        @task = Task.find(params[:id])

        if @task.user == current_user
          @task.update(task_params)
          render_resource(@task)
        else
          access_denied
        end
      end

      def destroy
        @task = Task.find(params[:id])

        if @task.user == current_user
          @task.destroy
          render_resource(@task)
        else
          access_denied
        end
      end

      private

      def set_task_parent
        # User must provide either project_id or section_id to create a new task
        # If project_id provided, find Project, otherwise find Section
        @taskable = if params[:project_id].present?
                      Project.find(params[:project_id])
                    else
                      Section.find(params[:section_id])
                    end

        # Set project_id (required) and section_id (optional)
        @project_id = params[:project_id] || @taskable.project.id
        @section_id = params[:section_id]
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date, :status)
      end
    end
  end
end

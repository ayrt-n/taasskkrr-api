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
        if params[:project_id].present?
          @taskable = Project.find(params[:project_id])
          @project_id = params[:project_id]
          @section_id = nil
        elsif params[:section_id].present?
          @taskable = Section.find(params[:section_id])
          @project_id = @taskable.project.id
          @section_id = params[:section_id]
        end
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date, :status)
      end
    end
  end
end

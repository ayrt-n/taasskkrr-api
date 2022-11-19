module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task_parent, only: %i[create]

      def index
        @tasks = current_user.tasks.order(:due_date)
        render json: { tasks: @tasks }
      end

      def create
        if @taskable.user == current_user
          @task = @taskable.tasks.create(task_params)
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
        @taskable = if params[:project_id].present?
                      Project.find(params[:project_id])
                    elsif params[:section_id].present?
                      Section.find(params[:section_id])
                    end
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date, :status).merge(user: current_user)
      end
    end
  end
end

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
        @task = @tasks.create(task_params)

        render_resource(@task)
      end

      def update
        @task = Task.find(params[:id])
        @task.update(task_params)

        render_resource(@task)
      end

      def destroy
        @task = Task.find(params[:id])
        @task.destroy

        render_resource(@task)
      end

      private

      def set_task_parent
        @tasks = if params[:project_id].present?
                   Project.find(params[:project_id]).tasks
                 elsif params[:section_id].present?
                   Section.find(params[:section_id]).tasks
                 else
                   # Handle no params?
                 end
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date).merge(user: current_user)
      end
    end
  end
end

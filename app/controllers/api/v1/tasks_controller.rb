module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task_parent, only: %i[create]
      before_action :authenticate_user!

      def index
        @tasks = current_user.tasks.order(:due_date)
        render json: { tasks: @tasks }
      end

      def create
        @task = @tasks.new(task_params)

        if @task.save
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @task = Task.find(params[:id])

        if @task.update(task_params)
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task = Task.find(params[:id])

        if @task.destroy
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_task_parent
        @tasks = if params[:project_id].present?
                   Project.find(params[:project_id]).tasks
                 elsif params[:section_id].present?
                   Section.find(params[:section_id]).tasks
                 elsif params[:task_id].present?
                   Task.find(params[:task_id]).sub_tasks
                 else
                   # Handle no params?
                 end
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date)
      end
    end
  end
end

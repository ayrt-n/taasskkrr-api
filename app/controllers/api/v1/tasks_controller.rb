module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task_parent, only: %i[create]

      def create
        @task = @parent.tasks.new(task_params)

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
        if params[:project_id].present?
          @parent = Project.find(params[:project_id])
        elsif params[:section_id].present?
          @parent = Section.find(params[:section_id])
        elsif params[:task_id].present?
          @parent = Task.find(params[:task_id])
        else
          # TODO: What should be done in case of no param?
        end
      end

      def task_params
        params.require(:task).permit(:title, :description, :priority, :due_date)
      end
    end
  end
end

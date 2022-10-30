module Api
  module V1
    class ProjectsController < ApplicationController
      def show
        @project = Project.include_all_tasks.find(params[:id])

        render json: @project
      end

      def create
        @project = Project.new(project_params)

        if @project.save
          render json: @project
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @project = Project.find(params[:id])

        if @project.update(project_params)
          render json: @project
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @project = Project.find(params[:id])

        if @project.destroy
          render @project
        else
          render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def project_params
        params.require(:project).permit(:title)
      end
    end
  end
end

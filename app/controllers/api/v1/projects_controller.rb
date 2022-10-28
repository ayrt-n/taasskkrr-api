module Api
  module V1
    class ProjectsController < ApplicationController
      def show
        @project = Project.find(params[:id])

        render json: @project
      end

      def create
        @project = Project.new(project_params)

        if @project.save
          render json: @project
        else
          render json: @project.errors.full_messages, status: :unprocessable_entity
        end
      end

      private

      def project_params
        params.require(:project).permit(:title)
      end
    end
  end
end
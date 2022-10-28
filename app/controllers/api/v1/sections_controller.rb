module Api
  module V1
    class SectionsController < ApplicationController
      def create
        @project = Project.find(params[:project_id])
        @section = @project.sections.new(section_params)

        if @section.save
          render json: @section
        else
          render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @section = Section.find(params[:id])

        if @section.update(section_params)
          render json: @section
        else
          render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @section = Section.find(params[:id])

        if @section.destroy
          render json: @section
        else
          render json: { errors: @section.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def section_params
        params.require(:section).permit(:title)
      end
    end
  end
end

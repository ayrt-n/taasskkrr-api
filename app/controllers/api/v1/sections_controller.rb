module Api
  module V1
    class SectionsController < ApplicationController
      before_action :authenticate_user!

      def create
        @project = Project.find(params[:project_id])

        if @project.user == current_user
          @section = @project.sections.create(section_params)
          render_resource(@section)
        else
          access_denied
        end
      end

      def update
        @section = Section.find(params[:id])

        if @section.user == current_user
          @section.update(section_params)
          render_resource(@section)
        else
          access_denied
        end
      end

      def destroy
        @section = Section.find(params[:id])

        if @section.user == current_user
          @section.destroy
          render_resource(@section)
        else
          access_denied
        end
      end

      private

      def section_params
        params.require(:section).permit(:title)
      end
    end
  end
end

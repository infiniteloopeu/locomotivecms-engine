module Locomotive
  module Concerns
    module SiteDispatcherController

      extend ActiveSupport::Concern

      included do
        if self.respond_to?(:before_filter)
          helper_method :current_site
        end
      end

      protected

      def current_site
        @current_site = Locomotive::Site.first # ||= request.env['locomotive.site']
      end

      def current_site?
        !current_site.nil?
      end

      def require_site
        return true if current_site?

        render_no_site_error
      end

      def render_no_site_error
        respond_to do |format|
          format.html do
            render template: '/locomotive/errors/no_site', layout: false, status: :not_found
          end
          format.json do
            render json: { error: 'No site found' }, status: :not_found
          end
        end
      end

    end
  end
end

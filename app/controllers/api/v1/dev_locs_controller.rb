module Api
    module V1
        
        class DevLocsController < ApiController
            
            # GET /api/v1/dev_locs
            def index
                render json: DeviceLocation.all
            end
            
        end     # class
        
    end # module V1
end     # module Api

## dev_locs_controller.rb
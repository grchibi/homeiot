module Api
    module V1
        
        class Api::V1::ApiController < ActionController::API
            private

            def block_external_hosts
                return false if white_listed?(request.remote_ip)
                redirect_to "https://www.google.com"
            end
            
            def white_listed?(ip)
                unless ip.nil?
                    IpRestriction.where(list_type: 'w').where(enabled: true).each do |white_ip|
                        return true if ip == white_ip.ip
                    end
                end
                
                logger.warn("WARNING!!! API WAS CALLED FROM RESTRICTED SOURCE IP. => #{ip}")
                
                false
            end
            
        end

    end    # module V1
end    # module Api

## api_controller.rb
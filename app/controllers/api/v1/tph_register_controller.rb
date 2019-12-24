module Api
    module V1
        
        class TphRegisterController < ApiController
            before_action :block_external_hosts         # IP RESTRICTION
                    
            # POST /api/v1/tph_register
            def create
                json_hash = params[:tph_register]
                
                ret_json = nil
                ret_sts = nil
                begin
                    p_device = IotDevice.find_by(uname: json_hash['dsrc'])
                    if p_device
                        p_device.tph_records.create(dt: json_hash['dt'], t: json_hash['t'], p: json_hash['p'], h: json_hash['h'])
                        #tmp_d = TphData.new(dt: json_hash['dt'], t: json_hash['t'], p: json_hash['p'], h: json_hash['h'])
                        #p_device.tph_datum << tmp_d
                        #p_device.tph_datum.build( { dt: json_hash['dt'], t: json_hash['t'], p: json_hash['p'], h: json_hash['h'] } )
                    
                        ret_json = {status: 'SUCCESS'}
                        ret_sts = :ok
                    else
                        logger.error("Couldn't find IotDevice. The data[dsrc=>#{json_hash['dsrc']}] sent by one device was invalid.")
                        
                        ret_json = {status: 'FAILED'}
                        ret_sts = 500
                    end
                    
                rescue ActiveRecord::RecordInvalid => ri_ex
                    logger.error(ri_ex.record.errors.full_messages)
                    
                    ret_json = {status: 'FAILED'}
                    ret_sts = 500
                rescue => ex
                    logger.error(ex.message)
                    
                    ret_json = {status: 'FAILED'}
                    ret_sts = 500
                end
                
                render json: ret_json, status: ret_sts
            end
                    
            private
                    
        end    # class

    end    # module V1
end    # module Api

## tph_register_controller.rb
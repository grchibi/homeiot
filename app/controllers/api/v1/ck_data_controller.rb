module Api
    module V1
        
        class CkDataController < ApiController
            
             # GET /api/v1/ck_data/get_h_by_h?devid=1&max=100
            def get_humid_by_h
                ret_dt = []
                
                begin
                    maxcnt = 24
                    if params[:max]
                        maxcnt = params[:max].to_i
                    end
                    
                    if params[:devid]
                        location = DeviceLocation.find(params[:devid])
                        
                        tmp_hash = get_humid_by_h_by_devid(location.iot_device_id, maxcnt)
                        ret_dt.push({:name => location.desc, :data => tmp_hash[:data], :min => tmp_hash[:min_h], :max => tmp_hash[:max_h]})
                    else
                        min_h = 100
                        max_h = -100
                        
                        DeviceLocation.all.each do |location|
                            tmp_hash = get_humid_by_h_by_devid(location.iot_device_id, maxcnt)
                            
                            min_h = tmp_hash[:min_h] if tmp_hash[:min_h] < min_h
                            max_h = tmp_hash[:max_h] if max_h < tmp_hash[:max_h]
                            
                            ret_dt.push({:name => location.desc, :data => tmp_hash[:data], :min => tmp_hash[:min_h], :max => tmp_hash[:max_h]})
                        end
                    end
                    
                rescue => ex
                    logger.error(ex.message)
                end
                
                render json: ret_dt
            end
            
            # GET /api/v1/ck_data/get_t_by_h?devid=1&max=100
            def get_temp_by_h
                ret_dt = []
                
                begin
                    maxcnt = 24
                    if params[:max]
                        maxcnt = params[:max].to_i
                    end
                    
                    if params[:devid]
                        location = DeviceLocation.find(params[:devid])
                        
                        tmp_hash = get_temp_by_h_by_devid(location.iot_device_id, maxcnt)
                        ret_dt.push({:name => location.desc, :data => tmp_hash[:data], :min => tmp_hash[:min_t], :max => tmp_hash[:max_t]})
                    else
                        min_t = 100
                        max_t = -100
                        
                        DeviceLocation.all.each do |location|
                            tmp_hash = get_temp_by_h_by_devid(location.iot_device_id, maxcnt)
                            
                            min_t = tmp_hash[:min_t] if tmp_hash[:min_t] < min_t
                            max_t = tmp_hash[:max_t] if max_t < tmp_hash[:max_t]
                            
                            ret_dt.push({:name => location.desc, :data => tmp_hash[:data], :min => tmp_hash[:min_t], :max => tmp_hash[:max_t]})
                        end
                    end
                    
                rescue => ex
                    logger.error(ex.message)
                end
                
                render json: ret_dt
            end
            
            private
            
            # For Chartkick
            def get_humid_by_h_by_devid(devid, maxcnt)
                ary = []
                min_h = 100
                max_h = -100
                
                begin
                    dbdata = TphRecord.where(iot_device_id: devid).order(created_at: :desc).limit(maxcnt)
                    dbdata.each do |rec|
                        ary.push([rec.dt, rec.h])
                        
                        min_h = rec.h if rec.h < min_h
                        max_h = rec.h if max_h < rec.h
                    end
                
                rescue => ex
                    logger.error(ex.message)
                end
                
                {:data => ary, :min_h => min_h, :max_h => max_h}
            end
            
            # For Chartkick
            def get_temp_by_h_by_devid(devid, maxcnt)
                ary = []
                min_t = 100
                max_t = -100
                
                begin
                    dbdata = TphRecord.where(iot_device_id: devid).order(created_at: :desc).limit(maxcnt)
                    dbdata.each do |rec|
                        ary.push([rec.dt, rec.t])
                        
                        min_t = rec.t if rec.t < min_t
                        max_t = rec.t if max_t < rec.t
                    end
                
                rescue => ex
                    logger.error(ex.message)
                end
                
                {:data => ary, :min_t => min_t, :max_t => max_t}
            end
            
        end     # class
        
    end # module V1
end     # module Api

## ck_data_controller.rb
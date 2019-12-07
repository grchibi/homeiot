module Api
    module V1
        
        class TphReferController < ApiController
            
            # GET /api/v1/tph_refer/latest
            def latest
                ret_json = nil
                ret_sts = nil
                
                begin
                    ret_json = { text: 'UNKO' }
                    
                    #    select tph_a.id, tph_a.dt, tph_a.t, tph_a.p, tph_a.h, tph_a.iot_device_id
                    #    from tph_records as tph_a
                    #    inner join (select iot_device_id, MAX(created_at) AS MaxCa from tph_records group by iot_device_id) as tph_b                          
                    #    on tph_a.iot_device_id = tph_b.iot_device_id
                    #    and tph_a.created_at = tph_b.MaxCa;
                    latests = TphRecord.find_by_sql(%|
                        SELECT tph_a.id, tph_a.dt, tph_a.t, tph_a.p, tph_a.h, tph_a.iot_device_id, iot_devices.uname
                        FROM tph_records AS tph_a
                        INNER JOIN (
                            SELECT iot_device_id, MAX(created_at) AS MaxCa
                            FROM tph_records
                            GROUP BY iot_device_id) as tph_b
                        ON tph_a.iot_device_id = tph_b.iot_device_id and tph_a.created_at = tph_b.MaxCa
                        LEFT JOIN iot_devices
                        ON tph_a.iot_device_id = iot_devices.id
                    |)
    
                    ret_json = { 'result': latests }
                    ret_sts = :ok
                    
                rescue => ex
                    logger.error(ex.message)
                
                    ret_json = {status: 'FAILED'}
                    ret_sts = 500
                end
                
                render json: ret_json, status: ret_sts
            end
            
            private
            
        end     # class
        
    end # module V1
end     # module Api

## tph_refer_controller.rb
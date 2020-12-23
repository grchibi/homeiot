class TphRecord < ApplicationRecord
    
    belongs_to :iot_devices#, class_name: 'IotDevice'
    
    validates :dt, presence: true
    
end

## tph_record.rb
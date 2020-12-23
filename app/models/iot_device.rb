class IotDevice < ApplicationRecord
    
    has_one :device_locations#, :class_name => 'DeviceLocation', foreign_key: 'iot_device_id'
    has_many :tph_records#, :class_name => 'TphRecord', foreign_key: 'iot_device_id'
    
    validates :uname, presence: true, uniqueness: true
    
end

## iot_device.rb
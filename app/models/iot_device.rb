class IotDevice < ApplicationRecord
    
    has_many :tph_records#, :class_name => 'TphRecord', foreign_key: 'iot_device_id'
    
    validates :uname, presence: true, uniqueness: true
    
end

## iot_device.rb
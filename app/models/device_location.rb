class DeviceLocation < ApplicationRecord
    belongs_to :iot_device#, class_name: 'IotDevice'
end

class DeviceLocation < ApplicationRecord
    belongs_to :iot_devices#, class_name: 'IotDevice'
end

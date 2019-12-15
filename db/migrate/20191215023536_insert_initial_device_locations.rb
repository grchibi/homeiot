class InsertInitialDeviceLocations < ActiveRecord::Migration[5.0]
  def change
    locations = [
      ['FR', 'Free Room', 0],
      ['WCL', 'Walk-in Closet', 1],
      ['ECL', 'Entrance Closet', 0]
    ]
    
    locations.each do |kword, desc, dev|
      DeviceLocation.create loc_ident: kword, desc: desc, iot_device_id: dev
    end
  end
end

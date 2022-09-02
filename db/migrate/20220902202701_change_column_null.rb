class ChangeColumnNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :applications, :name, false
    change_column_null :applications, :street_address, false
    change_column_null :applications, :city, false
    change_column_null :applications, :state, false
    change_column_null :applications, :zip_code, false
  end
end

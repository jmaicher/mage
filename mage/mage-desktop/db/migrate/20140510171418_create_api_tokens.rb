class CreateAPITokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.string :token
      t.references :api_authenticable, polymorphic: true
      t.boolean :expired, default: false

      t.timestamps
    end
  end
end

class CreateProfilesTable < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :avatar_url, null: false

      t.timestamps
    end
  end
end

class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, limit: 60
      t.string :abbrev, limit: 2
      t.index :abbrev, unique: true
      t.index :name, unique: true
    end

    abbrevs = {'Alabama': 'AL', 'Alaska': 'AK', 'Arizona': 'AZ', 'Arkansas': 'AR', 'California': 'CA', 'Colorado': 'CO', 'Connecticut': 'CT', 'Delaware': 'DE', 'Florida': 'FL', 'Georgia': 'GA', 'Hawaii': 'HI', 'Idaho': 'ID', 'Illinois': 'IL', 'Indiana': 'IN', 'Iowa': 'IA', 'Kansas': 'KS', 'Kentucky': 'KY', 'Louisiana': 'LA', 'Maine': 'ME', 'Maryland': 'MD', 'Massachusetts': 'MA', 'Michigan': 'MI', 'Minnesota': 'MN', 'Mississippi': 'MS', 'Missouri': 'MO', 'Montana': 'MT', 'Nebraska': 'NE', 'Nevada': 'NV', 'New Hampshire': 'NH', 'New Jersey': 'NJ', 'New Mexico': 'NM', 'New York': 'NY', 'North Carolina': 'NC', 'North Dakota': 'ND', 'Ohio': 'OH', 'Oklahoma': 'OK', 'Oregon': 'OR', 'Pennsylvania': 'PA', 'Rhode Island': 'RI', 'South Carolina': 'SC', 'South Dakota': 'SD', 'Tennessee': 'TN', 'Texas': 'TX', 'Utah': 'UT', 'Vermont': 'VT', 'Virginia': 'VA', 'Washington': 'WA', 'West Virginia': 'WV', 'Wisconsin': 'WI', 'Wyoming': 'WY', 'American Samoa': 'AS', 'District of Columbia': 'DC', 'Federated States of Micronesia': 'FM', 'Guam': 'GU', 'Marshall Islands': 'MH', 'Northern Mariana Islands': 'MP', 'Palau': 'PW', 'Puerto Rico': 'PR', 'Virgin Islands': 'VI', 'Armed Forces Africa, Canada, Europe, and Middle East': 'AE', 'Armed Forces Americas': 'AA', 'Armed Forces Pacific': 'AP',
      # plus some specials from the SSA:
    'Not issued': 'NI',
    'Railroad Board': 'RR', # (discontinued July 1, 1963)
    'Philippine Islands': 'PI', # (before independence from US, July 4, 1946)
    'Enumeration at Entry': 'EE'}

    abbrevs.each{|n,a| State.create name: n, abbrev: a}
  end
end
